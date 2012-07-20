//
// Copyright (c) 2011, Brian Frank and Andy Frank
// Licensed under the Academic Free License version 3.0
//
// History:
//   3 Feb 10  Andy Frank  Creation
//

/**
 * HyperlinkPeer.
 */
fan.webfwt.HyperlinkPeer = fan.sys.Obj.$extend(fan.webfwt.WebLabelPeer);
fan.webfwt.HyperlinkPeer.prototype.$ctor = function(self)
{
  fan.webfwt.WebLabelPeer.prototype.$ctor.call(this, self);
}

fan.webfwt.HyperlinkPeer.prototype.m_uri = fan.sys.Uri.m_defVal;
fan.webfwt.HyperlinkPeer.prototype.uri = function(self) { return this.m_uri; }
fan.webfwt.HyperlinkPeer.prototype.uri$ = function(self, val)
{
  this.m_rebuild = true;
  this.m_uri = val;
}

// backdoor hook to reuse Label for hyperlinks
fan.webfwt.HyperlinkPeer.prototype.$uri = function(self)
{
  return {
    uri: this.m_uri.encode(),
    target: self.m_target,
    underline: self.m_underline.toStr()
  };
}

