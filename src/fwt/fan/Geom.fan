//
// Copyright (c) 2008, Brian Frank and Andy Frank
// Licensed under the Academic Free License version 3.0
//
// History:
//   12 Jun 08  Brian Frank  Creation
//

**************************************************************************
** Point
**************************************************************************

**
** Point represents a coordinate in the display space.
**
@simple
const class Point
{
  ** Default instance is 0, 0.
  const static Point def := Point()

  ** Construct with optional x, y.
  new make(Int x := 0, Int y := 0) { this.x = x; this.y = y }

  ** Parse from string.  If invalid and checked is
  ** true then throw ParseErr otherwise return null.
  static Point fromStr(Str s, Bool checked := true)
  {
    try
    {
      comma := s.index(",")
      return make(s[0...comma].trim.toInt, s[comma+1..-1].trim.toInt)
    }
    catch {}
    if (checked) throw ParseErr("Invalid Point: $s")
    return null
  }

  ** Return 'x+tx, y+ty'
  Point translate(Point t) { return make(x+t.x, y+t.y) }

  ** Return hash of x and y.
  override Int hash() { return x.hash ^ (y.hash << 16) }

  ** Return if obj is same Point value.
  override Bool equals(Obj? obj)
  {
    that := obj as Point
    if (that == null) return false
    return this.x == that.x && this.y == that.y
  }

  ** Return '"x,y"'
  override Str toStr() { return "$x,$y" }

  ** X coordinate
  const Int x

  ** Y coordinate
  const Int y
}

**************************************************************************
** Size
**************************************************************************

**
** Size represents the width and height of a rectangle.
**
@simple
const class Size
{
  ** Default instance is 0, 0.
  const static Size def := Size()

  ** Construct with optional w, h.
  new make(Int w := 0, Int h := 0) { this.w = w; this.h = h }

  ** Parse from string.  If invalid and checked is
  ** true then throw ParseErr otherwise return null.
  static Size fromStr(Str s, Bool checked := true)
  {
    try
    {
      comma := s.index(",")
      return make(s[0...comma].trim.toInt, s[comma+1..-1].trim.toInt)
    }
    catch {}
    if (checked) throw ParseErr("Invalid Size: $s")
    return null
  }

  ** Return '"w,h"'
  override Str toStr() { return "$w,$h" }

  ** Return hash of w and h.
  override Int hash() { return w.hash ^ (h.hash << 16) }

  ** Return if obj is same Size value.
  override Bool equals(Obj? obj)
  {
    that := obj as Size
    if (that == null) return false
    return this.w == that.w && this.h == that.h
  }

  ** Width
  const Int w

  ** Height
  const Int h
}

**************************************************************************
** Rect
**************************************************************************

**
** Represents the x,y coordinate and w,h size of a rectangle.
**
@simple
const class Rect
{
  ** Default instance is 0, 0, 0, 0.
  const static Rect def := Rect()

  ** Construct with optional x, y, w, h.
  new make(Int x := 0, Int y := 0, Int w := 0, Int h := 0)
    { this.x = x; this.y = y; this.w = w; this.h = h }

  ** Construct from a Point and Size instance
  new makePosSize(Point p, Size s)
    { this.x = p.x; this.y = p.y; this.w = s.w; this.h= s.h }

  ** Parse from string.  If invalid and checked is
  ** true then throw ParseErr otherwise return null.
  static Rect fromStr(Str s, Bool checked := true)
  {
    try
    {
      c1 := s.index(",")
      c2 := s.index(",", c1+1)
      c3 := s.index(",", c2+1)
      return make(s[0...c1].trim.toInt, s[c1+1...c2].trim.toInt,
                  s[c2+1...c3].trim.toInt, s[c3+1..-1].trim.toInt)
    }
    catch {}
    if (checked) throw ParseErr("Invalid Rect: $s")
    return null
  }

  ** Get the x, y coordinate of this rectangle.
  Point pos() { return Point(x, y) }

  ** Get the w, h size of this rectangle.
  Size size() { return Size(w, h) }

  ** Return true if x,y is inside the bounds of this rectangle.
  Bool contains(Int x, Int y)
  {
    return x >= this.x && x <= this.x+w &&
           y >= this.y && y <= this.y+h
  }

  ** Return '"x,y,w,h"'
  override Str toStr() { return "$x,$y,$w,$h" }

  ** Return hash of x, y, w, and h.
  override Int hash()
  {
    return x.hash ^ (y.hash << 16) ^ (w.hash << 32) ^ (w.hash << 48)
  }

  ** Return if obj is same Rect value.
  override Bool equals(Obj? obj)
  {
    that := obj as Rect
    if (that == null) return false
    return this.x == that.x && this.y == that.y &&
           this.w == that.w && this.h == that.h
  }

  ** X coordinate
  const Int x

  ** Y coordinate
  const Int y

  ** Width
  const Int w

  ** Height
  const Int h
}

**************************************************************************
** Insets
**************************************************************************

**
** Insets represent a number of pixels around the edge of a rectangle.
**
@simple
const class Insets
{
  ** Default instance 0, 0, 0, 0.
  const static Insets def := Insets()

  ** Construct with optional top, right, bottom, left.  If one side
  ** is not specified, it is reflected from the opposite side:
  **
  **   Insets(5)     === Insets(5,5,5,5)
  **   Insets(5,6)   === Insets(5,6,5,6)
  **   Insets(5,6,7) === Insets(5,6,7,6)
  new make(Int top := 0, Int right := null, Int bottom := null, Int left := null)
  {
    if (right == null) right = top
    if (bottom == null) bottom = top
    if (left == null) left = right
    this.top = top
    this.right = right
    this.bottom = bottom
    this.left = left
  }

  ** Parse from string (see `toStr`).  If invalid and checked
  ** is true then throw ParseErr otherwise return null.  Supported
  ** formats are:
  **   - "len"
  **   - "top,right,bottom,left"
  static Insets fromStr(Str s, Bool checked := true)
  {
    try
    {
      c1 := s.index(",")
      if (c1 == null) { len := s.toInt; return make(len, len, len, len) }
      c2 := s.index(",", c1+1)
      c3 := s.index(",", c2+1)
      return make(s[0...c1].trim.toInt, s[c1+1...c2].trim.toInt,
                  s[c2+1...c3].trim.toInt, s[c3+1..-1].trim.toInt)
    }
    catch {}
    if (checked) throw ParseErr("Invalid Insets: $s")
    return null
  }

  ** If all four sides are equal return '"len"'
  ** otherwise return '"top,right,bottom,left"'.
  override Str toStr()
  {
    if (top == right && top == bottom && top == left)
      return top.toStr
    else
      return "$top,$right,$bottom,$left"
  }

  ** Return hash of top, right, bottom, left.
  override Int hash()
  {
    return top.hash ^ (right.hash << 16) ^ (bottom.hash << 32) ^ (left.hash << 48)
  }

  ** Return if obj is same Insets value.
  override Bool equals(Obj? obj)
  {
    that := obj as Insets
    if (that == null) return false
    return this.top == that.top && this.right == that.right &&
           this.bottom == that.bottom && this.left == that.left
  }

  ** Return right+left, top+bottom
  Size toSize() { return Size(right+left, top+bottom) }

  ** Top side spacing
  const Int top

  ** Right side spacing
  const Int right

  ** Bottom side spacing
  const Int bottom

  ** Left side spacing
  const Int left
}

**************************************************************************
** Hints
**************************************************************************

**
** Hints are used to pass contraints into Widget.prefSize.
**
const class Hints
{

  ** Default instance is null, null.
  const static Hints def := Hints(null, null)

  ** Construct with optional w, h.
  new make(Int w := null, Int h := null) { this.w = w; this.h = h }

  ** Return '"w,h"'
  override Str toStr() { return "$w,$h" }

  ** Return hash of w and h.
  override Int hash()
  {
    return (w == null ? 3 : w.hash) ^((h == null ? 11 : h.hash) << 16)
  }

  ** Return if obj is same Hints value.
  override Bool equals(Obj? obj)
  {
    that := obj as Hints
    if (that == null) return false
    return this.w == that.w && this.h == that.h
  }

  ** Add the given w and h to this hint's dimensions.  If a hint
  ** dimension is null, then the resulting dimension is null too.
  Hints plus(Size size)
  {
    return make(w == null ? null : w + size.w,
                h == null ? null : h + size.h)
  }

  ** Subtract the given w and h from this hint's dimensions.  If a hint
  ** dimension is null, then the resulting dimension is null too.
  Hints minus(Size size)
  {
    return make(w == null ? null : w - size.w,
                h == null ? null : h - size.h)
  }

  ** Suggested width or null if no contraints
  const Int w

  ** Suggested height or null if no contraints
  const Int h
}