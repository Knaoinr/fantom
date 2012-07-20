//
// Copyright (c) 2011, Brian Frank and Andy Frank
// Licensed under the Academic Free License version 3.0
//
// History:
//   12 Jul 2011  Andy Frank  Creation
//

using gfx
using fwt

**
** StyledButton is a customizable button that wraps a content widget.
**
@Js
class StyledButton : ContentPane
{
  ** It-block constructor.
  new make(|This|? f := null)
  {
    if (f != null) f(this)
  }

  ** Construct HUD style button.
  new makeHud(|This|? f := null)
  {
    border      = Border("#131313 5")
    bg          = Gradient("0% 0%, 0% 100%, #5b5b5b, #393939")
    bgPressed   = Gradient("0% 0%, 0% 100%, #333, #484848")
    dropShadow  = Shadow("#555 0 1")
    innerShadow = Shadow("#555 0 1")
    innerShadowPressed = Shadow("#222 0 1")
    if (f != null) f(this)
  }

  ** Border of button, or null for none.
  const Border? border := Border("#555 5")

  ** Insets betwee content and button border.
  const Insets insets := Insets(3,12)

  ** Inner shadow color, of null for none.
  const Shadow? innerShadow := Shadow("#fff 0 1")

  ** Inner shadow color when button is pressed, of null for none.
  const Shadow? innerShadowPressed := Shadow("#888 0 1")

  ** Drop shadow color, or null for none.
  const Shadow? dropShadow := Shadow("#fff 0 1")

  ** Background brush for button, or null for none.
  const Brush? bg := Gradient("0% 0%, 0% 100%, #fefefe, #bbb")

  ** Background brush when button is pressed, or null for none.
  const Brush? bgPressed := Gradient("0% 0%, 0% 100%, #a9a9a9, #bbb")

  ** Tooltip to display on mouse hover, or null for none.
  const Str? toolTip := null

  ** ButtonMode - only push and toggle are supported.
  const ButtonMode mode := ButtonMode.push

  ** The button's selected state (if toggle).
  Bool selected := false
  {
    set { &selected=it; updateState }
  }

  ** Command associated with this button.  Setting the
  ** command automatically maps the enable state and
  ** eventing to the command.
  Command? command
  {
    set
    {
      newVal := it
      this.&command?.unregister(this)
      this.&command = newVal
      if (newVal != null)
      {
        enabled = newVal.enabled
        onAction.add |e| { newVal.invoke(e) }
        newVal.register(this)
      }
    }
  }

  ** EventListener invoked when button is pressed.
  once EventListeners onAction() { EventListeners() }

  ** EventListener invoked when button is moved to pressed state.
  ** Use `onAction` to properly register button action events.
  once EventListeners onPressed() { EventListeners() }

  ** EventListener invoked when button is moved to released state.
  ** Use `onAction` to properly register button action events.
  once EventListeners onReleased() { EventListeners() }

  ** Fire 'onAction' event.
  private Void fireAction()
  {
    onAction.fire(Event { id=EventId.action; widget=this })
  }

  override Size prefSize(Hints hints := Hints.defVal)
  {
    if (content == null) return Size(100,40)

    p := content.prefSize
    w := p.w + insets.left + insets.right
    h := p.h + insets.top + insets.bottom

    if (border != null)
    {
      w += border.widthLeft + border.widthRight
      h += border.widthTop + border.widthBottom
    }

    if (dropShadow != null)
      h += dropShadow.offset.y + dropShadow.blur + dropShadow.spread

    return Size(w,h)
  }

  override Void onLayout()
  {
    c := content
    if (c == null) return

    p := content.prefSize
    w := size.w - (insets.left + insets.right)
    h := size.h - (insets.top + insets.bottom)

    if (border != null)
    {
      w -= border.widthLeft + border.widthRight
      h -= border.widthTop + border.widthBottom
    }

    if (dropShadow != null)
      h -= dropShadow.offset.y + dropShadow.blur + dropShadow.spread

    cw := w.min(p.w)
    ch := h.min(p.h)
    cx := insets.left + ((w-cw) / 2)
    cy := insets.top + ((h-ch) / 2)

    c.bounds = Rect(cx, cy, cw, ch)
  }

  private native Void updateState()
}

