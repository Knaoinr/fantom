//
// Copyright (c) 2006, Brian Frank and Andy Frank
// Licensed under the Academic Free License version 3.0
//
// History:
//    2 Dec 05  Brian Frank  Creation
//   11 Oct 06  Brian Frank  Rename Real to Float
//

**
** Float is used to represent a 64-bit floating point number.
**
const final class Float : Num
{

//////////////////////////////////////////////////////////////////////////
// Constructor
//////////////////////////////////////////////////////////////////////////

  **
  ** Make a Float for the specified 64-bit representation according
  ** IEEE 754 floating-point double format bit layout.  This method is
  ** paired with `Float.bits`.
  **
  static Float makeBits(Int bits)

  **
  ** Make a Float for the specified 32-bit representation according
  ** IEEE 754 floating-point single format bit layout.  This method is
  ** paired with `Float.bits32`.
  **
  static Float makeBits32(Int bits)

  **
  ** Parse a Str into a Float.  Representations for infinity and
  ** not-a-number are "-INF", "INF", "NaN".  This string format matches
  ** the lexical representation of Section 3.2.5 of XML Schema Part 2.
  ** If invalid format and checked is false return null, otherwise throw
  ** ParseErr.
  **
  ** TODO: need spec - follow XML Schema literal definition
  **
  static Float? fromStr(Str s, Bool checked := true)

  **
  ** Private constructor.
  **
  private new make()

  **
  ** Float value for positive infinity.
  **
  const static Float posInf

  **
  ** Float value for negative infinity.
  **
  const static Float negInf

  **
  ** Float value for Not-A-Number.
  **
  const static Float nan

  **
  ** Float value for e which is the base of natural logarithms.
  **
  const static Float e

  **
  ** Float value for pi which is the ratio of the
  ** circumference of a circle to its diameter.
  **
  const static Float pi

//////////////////////////////////////////////////////////////////////////
// Obj Overrides
//////////////////////////////////////////////////////////////////////////

  **
  ** Return true if same float value.  Unlike Java, NaN equals NaN.
  **
  override Bool equals(Obj? obj)

  **
  ** Return if this Float is approximately equal to the given Float by the
  ** specified tolerance.  If tolerance is null, then it is computed
  ** using the magnitude of the two Floats.  It is useful for comparing
  ** Floats since often they loose a bit of precision during manipulation.
  ** This method is equivalent to:
  **   if (tolerance == null) tolerance = min(abs(this/1e6), abs(r/1e6))
  **   (this - r).abs < tolerance
  **
  Bool approx(Float r, Float? tolerance := null)

  **
  ** Compare based on floating point value.
  **
  override Int compare(Obj obj)

  **
  ** Return bits().
  **
  override Int hash()

//////////////////////////////////////////////////////////////////////////
// Methods
//////////////////////////////////////////////////////////////////////////

  **
  ** Negative of this.  Shortcut is -a.
  **
  Float negate()

  **
  ** Multiply this with b.  Shortcut is a*b.
  **
  Float mult(Float b)

  **
  ** Divide this by b.  Shortcut is a/b.
  **
  Float div(Float b)

  **
  ** Return remainder of this divided by b.  Shortcut is a%b.
  **
  Float mod(Float b)

  **
  ** Add this with b.  Shortcut is a+b.
  **
  Float plus(Float b)

  **
  ** Subtract b from this.  Shortcut is a-b.
  **
  Float minus(Float b)

  **
  ** Increment by one.  Shortcut is ++a or a++.
  **
  Float increment()

  **
  ** Decrement by one.  Shortcut is --a or a--.
  **
  Float decrement()

/////////////////////////////////////////////////////////////////////////
// Math
//////////////////////////////////////////////////////////////////////////

  **
  ** Return the absolute value of this float.  If this value is
  ** positive then return this, otherwise return the negation.
  **
  Float abs()

  **
  ** Return the smaller of this and the specified Float values.
  **
  Float min(Float that)

  **
  ** Return the larger of this and the specified Float values.
  **
  Float max(Float that)

  **
  ** Returns the smallest whole number greater than or equal
  ** to this number.
  **
  Float ceil()

  **
  ** Returns the largest whole number less than or equal to
  ** this number.
  **
  Float floor()

  **
  ** Returns the nearest whole number to this number.
  **
  Float round()

  **
  ** Return e raised to this power.
  **
  Float exp()

  **
  ** Return natural logarithm of this number.
  **
  Float log()

  **
  ** Return base 10 logarithm of this number.
  **
  Float log10()

  **
  ** Return this value raised to the specified power.
  **
  Float pow(Float pow)

  **
  ** Return square root of this value.
  **
  Float sqrt()

//////////////////////////////////////////////////////////////////////////
// Trig
//////////////////////////////////////////////////////////////////////////

  **
  ** Return the arc cosine.
  **
  Float acos()

  **
  ** Return the arc sine.
  **
  Float asin()

  **
  ** Return the arc tangent.
  **
  Float atan()

  **
  ** Converts rectangular coordinates (x, y) to polar (r, theta).
  **
  static Float atan2(Float y, Float x)

  **
  ** Return the cosine of this angle in radians.
  **
  Float cos()

  **
  ** Return the hyperbolic cosine.
  **
  Float cosh()

  **
  ** Return sine of this angle in radians.
  **
  Float sin()

  **
  ** Return hyperbolic sine.
  **
  Float sinh()

  **
  ** Return tangent of this angle in radians.
  **
  Float tan()

  **
  ** Return hyperbolic tangent.
  **
  Float tanh()

  **
  ** Convert this angle in radians to an angle in degrees.
  **
  Float toDegrees()

  **
  ** Convert this angle in degrees to an angle in radians.
  **
  Float toRadians()

//////////////////////////////////////////////////////////////////////////
// Conversion
//////////////////////////////////////////////////////////////////////////

  **
  ** Return 64-bit representation according IEEE 754 floating-point
  ** double format bit layout.  This method is paired with `Float.makeBits`.
  **
  Int bits()

  **
  ** Return 32-bit representation according IEEE 754 floating-point
  ** single format bit layout.  This method is paired with `Float.makeBits32`.
  **
  Int bits32()

  **
  ** Get string representation according to the lexical representation defined
  ** by Section 3.2.5 of XML Schema Part 2.  Representations for infinity and
  ** not-a-number are "-INF", "INF", "NaN".
  **
  override Str toStr()

}