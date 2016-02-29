//
// Copyright (c) 2016, Direct Control
// All Rights Reserved
//
// History:
//   18 Feb 16   Matthew Walker   Creation
//

using util
using haystack
using proj
using hisExt
using hisKitExt
using concurrent


**
** Some class documentation, just to see if it works.
**
class Rule01Test : ProjTest
{
  // Get the current system time zone.  Extract the city name as that is all
  // that is used for the Haystack 'tz' tag.  See project-haystack.org/tag/tz
  static const Str currentTz := TimeZone.cur().name


  static Ref createDischargeAirTempModel(Proj proj, Ref equipRef, Str kind := "Number")
  {
    // Create Cool point
    diff := Diff.makeAdd( ["discharge"  : Marker.val,
                           "air"        : Marker.val,
			   "temp"       : Marker.val,
			   "sensor"     : Marker.val,
			   "unit"       : "K",
			   // TODO: siteRef???
                           "point"      : Marker.val,
                           "his"        : Marker.val,
                           "tz"         : currentTz,
                           "kind"       : kind,
	                   "equipRef"   : equipRef] )
    diff2 := proj.commit(diff)
    return diff2.id
  }


  static Ref createMixedAirTempModel(Proj proj, Ref equipRef, Str kind := "Number")
  {
    // Create Cool point
    diff := Diff.makeAdd( ["mixed"      : Marker.val,
                           "air"        : Marker.val,
			   "temp"       : Marker.val,
			   "sensor"     : Marker.val,
			   "unit"       : "K",
			   // TODO: siteRef???
                           "point"      : Marker.val,
                           "his"        : Marker.val,
                           "tz"         : currentTz,
                           "kind"       : kind,
	                   "equipRef"   : equipRef] )
    diff2 := proj.commit(diff)
    return diff2.id
  }


  static Ref createReturnAirTempModel(Proj proj, Ref equipRef, Str kind := "Number")
  {
    // Create Cool point
    diff := Diff.makeAdd( ["return"     : Marker.val,
                           "air"        : Marker.val,
			   "temp"       : Marker.val,
			   "sensor"     : Marker.val,
			   "unit"       : "K",
			   // TODO: siteRef???
                           "point"      : Marker.val,
                           "his"        : Marker.val,
                           "tz"         : currentTz,
                           "kind"       : kind,
	                   "equipRef"   : equipRef] )
    diff2 := proj.commit(diff)
    return diff2.id
  }



  static Str:Ref createBasicModel(Proj? proj := null)
  {
    if (proj==null) proj = Context.cur.proj

    // Create AHU record
    diff := proj::Diff.makeAdd( ["ahu" : haystack::Marker.val] )
    diff2 := proj.commit(diff)
    ahuRef := diff2.id
    
    // Create discharge air temp point
    dischargeAirTempRef := createDischargeAirTempModel(proj, ahuRef)

    // Create mixed air temp point
    mixedAirTempRef := createMixedAirTempModel(proj, ahuRef)

    // Create return air temp point
    returnAirTempRef := createReturnAirTempModel(proj, ahuRef)

    return ["ahuRef":              ahuRef,
            "dischargeAirTempRef": dischargeAirTempRef,
	    "mixedAirTempRef":     mixedAirTempRef,
	    "returnAirTempRef":    returnAirTempRef]
  }





  **
  ** Test that an exception is thrown if 'null' is passed as the record
  **
  @DbTest
  Void testRule01WithNullRecord()
  {
    // Include extensions that provide necessary Axon functions
    addExtRec(ahuPerformanceAssessmentRulesExt::AhuPerformanceAssessmentRulesExt#) 
    
    context := makeSuContext()
    fn := context.evalToFunc("aparRule01")
    result := null
    exceptionCaught := false
    try {
      result = fn.call(context, [null, null])
    }
    catch {
      exceptionCaught = true
    }

    // Check that an exception was thrown
    verifyEq( exceptionCaught, true )
  }


  **
  ** Test that we return null if the records are correct but there's no data
  **
/*
  @DbTest
  Void testRule01WithCorrectRecordsButNoData()
  {
    // Include extensions that provide necessary Axon functions
    addExtRec(ahuPerformanceAssessmentRulesExt::AhuPerformanceAssessmentRulesExt#) 
    
    context := makeSuContext()
    fn := context.evalToFunc("aparRule01")
    result := null
    result = fn.call(context, [ref, null])

    // Check that an exception was thrown
    verifyEq( exceptionCaught, true )
  }
*/

  @DbTest
  Void testBasicModelIsComplete()
  {
    ahuRef := createBasicModel(proj)["ahuRef"]
    verifyEq(AhuPerformanceAssessmentRulesLib.testModelRule01(ahuRef, proj), null)
  }


}

