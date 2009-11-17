//
// Copyright (c) 2006, Brian Frank and Andy Frank
// Licensed under the Academic Free License version 3.0
//
// History:
//   23 Dec 05  Brian Frank  Creation
//
package fan.sys;

import java.io.File;
import java.io.FileOutputStream;
import java.net.*;
import java.security.*;
import java.util.*;
import fanx.emit.*;
import fanx.util.*;

/**
 * FanClassLoader is used to emit fcode to Java bytecode.  It manages
 * the "fan." namespace to map to dynamically loaded Fan classes.
 */
public class FanClassLoader
  extends URLClassLoader
{

//////////////////////////////////////////////////////////////////////////
// FanClassLoader
//////////////////////////////////////////////////////////////////////////

  public static Class loadClass(String name, Box classfile)
  {
    if (Sys.usePrecompiledOnly)
      throw new IllegalStateException("Attempt to use FanClassLoader under precompiled only mode");

    if (classfile == null)
      throw new IllegalStateException("null classfile");

    try
    {
      synchronized(pendingClasses)
      {
        pendingClasses.put(name, classfile);
      }
      return classLoader.loadClass(name);
    }
    catch (ClassNotFoundException e)
    {
      e.printStackTrace();
      throw Err.make("Cannot load class: " + name, e).val;
    }
  }

//////////////////////////////////////////////////////////////////////////
// Constructor
//////////////////////////////////////////////////////////////////////////

  public FanClassLoader()
  {
    this(FanClassLoader.class.getClassLoader());
  }

  private FanClassLoader(ClassLoader parent)
  {
    super(getExtUrls(), parent);
    try
    {
      this.allPermissions = new AllPermission().newPermissionCollection();
      this.codeSource = new CodeSource(new java.net.URL("file://"), (CodeSigner[])null);
    }
    catch (Throwable e)
    {
      e.printStackTrace();
    }
  }

  private static URL[] getExtUrls()
  {
    try
    {
      String sep = File.separator;
      File extDir = new File(Sys.HomeDir, "lib" + sep + "java" + sep + "ext");
      File platDir = new File(extDir, Sys.platform());
      ArrayList acc = new ArrayList();
      addExtJars(acc, extDir);
      addExtJars(acc, platDir);
      return (URL[])acc.toArray(new URL[acc.size()]);
    }
    catch (Exception e)
    {
      e.printStackTrace();
      return new URL[0];
    }
  }

  private static void addExtJars(ArrayList acc, File extDir) throws Exception
  {
    File[] list = extDir.listFiles();
    for (int i=0; list != null && i<list.length; ++i)
      if (list[i].getName().endsWith(".jar")) acc.add(list[i].toURL());
  }

//////////////////////////////////////////////////////////////////////////
// ClassLoader
//////////////////////////////////////////////////////////////////////////

  protected PermissionCollection getPermissions(CodeSource src)
  {
    return allPermissions;
  }

  protected Class findClass(String name)
    throws ClassNotFoundException
  {
    // first check if the classfile in my pending queue
    Box pending = null;
    synchronized(pendingClasses)
    {
      pending = (Box)pendingClasses.get(name);
      if (pending != null) pendingClasses.remove(name);
    }

    // if it was pending, then use that to define new class
    if (pending != null)
    {
// if (name.endsWith("")) dumpToFile(name, pending);
      Class cls = defineClass(name, pending.buf, 0, pending.len, codeSource);
      return cls;
    }

    // anything starting with "fan." maps to a Fan Type (or native peer code)
    if (name.startsWith("fan."))
    {
      // fan.{pod}.{type}
      int dot = name.indexOf('.', 4);
      String podName  = name.substring(4, dot);
      String typeName = name.substring(dot+1);
      Pod pod = Pod.doFind(podName, true, null, null);

      // see if we can find a precompiled class
      if (pod.fpod.store != null)
      {
        try
        {
          String path = "fan/" + podName + "/" + typeName + ".class";
          Box precompiled = pod.fpod.store.readToBox(path);
          if (precompiled != null)
          {
//dumpToFile(name, precompiled);
            Class cls = defineClass(name, precompiled.buf, 0, precompiled.len, codeSource);

            // if the precompiled class is a fan type, then we need
            // to finish the emit process since we skipped the normal
            // code path thru Type.emit() for fcode to bytecode generation
            ClassType type = (ClassType)pod.findType(typeName, false);
            if (type != null) type.precompiled(cls);

            // if the class is a precompiled Pod type
            else if (typeName.equals("$Pod")) pod.precompiled(cls);

            return cls;
          }
        }
        catch (Exception e)
        {
          e.printStackTrace();
        }
      }

      // ensure pod is emitted with our constant pool before
      // loading any classes inside of it (if this was the
      // actual class to load, then we are done)
      pod.emit();
      if (typeName.equals("$Pod")) return pod.emit();

      // if the type name ends with $ then this is a mixin body
      // class being used before we have loaded the mixin interface,
      // so load them both, then we should it registered by name;
      // same goes for $Val for Err value types
      if (typeName.endsWith("$") || typeName.endsWith("$Val"))
      {
        int strip = typeName.endsWith("$") ? 1 : 4;
        ClassType t = (ClassType)pod.findType(typeName.substring(0, typeName.length()-strip), true);
        Class cls = t.emit();
        return loadClass(name);
      }

      // if there wasn't a precompiled class, then this must
      // be a normal fcode type which we need to emit
      ClassType t = (ClassType)pod.findType(typeName, true);
      return t.emit();
    }

    // fallback to default URLClassLoader loader
    // implementation which searches my ext jars
    try
    {
      return super.findClass(name);
    }
    catch (NoClassDefFoundError e)   { checkLoadFailure(name); throw e; }
    catch (ClassNotFoundException e) { checkLoadFailure(name); throw e; }
  }

  private static void checkLoadFailure(String name)
  {
    if (name.contains("eclipse.swt"))
      System.out.println("ERROR: cannot load SWT library - see `http://fantom.org/doc/docTools/Setup.html#swt`");
  }

//////////////////////////////////////////////////////////////////////////
// Debug
//////////////////////////////////////////////////////////////////////////

  static void dumpToFile(String name, Box classfile)
  {
    try
    {
      File f = new File(name.substring(name.lastIndexOf('.')+1) + ".class");
      System.out.println("Dump: " + f);
      FileOutputStream out = new FileOutputStream(f);
      out.write(classfile.buf, 0, classfile.len);
      out.close();
    }
    catch (Exception e)
    {
      e.printStackTrace();
    }
  }

//////////////////////////////////////////////////////////////////////////
// Fields
//////////////////////////////////////////////////////////////////////////

  private static FanClassLoader classLoader = new FanClassLoader(FanClassLoader.class.getClassLoader());
  private static HashMap pendingClasses = new HashMap(); // name -> Box

  private PermissionCollection allPermissions;
  private CodeSource codeSource;
}