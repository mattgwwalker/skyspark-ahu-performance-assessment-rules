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
** AhuPerformanceAssessmentRulesTest
**
class AhuPerformanceAssessmentRulesTest : ProjTest
{
  static Ref createCoolModel(Proj proj, Ref equipRef, Str kind := "Bool")
  {
    // Create Cool point
    diff := Diff.makeAdd( ["cool"  : Marker.val,
                           "point" : Marker.val,
                           "his"   : Marker.val,
                           "tz"    : "Auckland",
                           "kind"  : kind,
	                   "equipRef": equipRef] )
    diff2 := proj.commit(diff)
    return diff2.id
  }


  static Ref createHeatModel(Proj proj, Ref equipRef, Str kind := "Bool")
  {
    // Create Cool point
    diff := Diff.makeAdd( ["heat"  : Marker.val,
                           "point" : Marker.val,
                           "his"   : Marker.val,
                           "tz"    : "Auckland",
                           "kind"  : kind,
	                   "equipRef": equipRef] )
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

    // Create Cool point
    coolRef := createCoolModel(proj, ahuRef)

    // Create Heat point
    heatRef := createHeatModel(proj, ahuRef)

    return ["ahuRef":ahuRef, "coolRef":coolRef, "heatRef":heatRef]
  }


  static Str:Ref createBasicNumericModel(Proj? proj := null)
  {
    if (proj==null) proj = Context.cur.proj

    // Create AHU record
    diff := proj::Diff.makeAdd( ["ahu" : haystack::Marker.val] )
    diff2 := proj.commit(diff)
    ahuRef := diff2.id

    // Create Cool point
    coolRef := createCoolModel(proj, ahuRef, "Number")

    // Create Heat point
    heatRef := createHeatModel(proj, ahuRef, "Number")

    return ["ahuRef":ahuRef, "coolRef":coolRef, "heatRef":heatRef]
  }


  static Str:Ref createMultiStageModel(Proj? proj := null)
  {
    if (proj==null) proj = Context.cur.proj

    // Create AHU record
    diff := proj::Diff.makeAdd( ["ahu" : haystack::Marker.val] )
    diff2 := proj.commit(diff)
    ahuRef := diff2.id

    // Create Cool point
    coolRef1 := createCoolModel(proj, ahuRef)
    coolRef2 := createCoolModel(proj, ahuRef)

    // Create Heat point
    heatRef1 := createHeatModel(proj, ahuRef)
    heatRef2 := createHeatModel(proj, ahuRef)

    return ["ahuRef":   ahuRef,
            "coolRef1": coolRef1,
	    "coolRef2": coolRef2,
	    "heatRef1": heatRef1,
	    "heatRef2": heatRef2,]
  }





  @DbTest
  Void testSparkWhenHeatingAndCoolingOnBasicModel()
  {
    addExtRec(hisExt::HisExt#)
    his := (HisExt)proj.ext("his")
    
    refs := createBasicModel(proj)
    ahuRef := refs["ahuRef"]
    coolRef := refs["coolRef"]
    heatRef := refs["heatRef"]
    coolRec := proj.readById(coolRef)
    heatRec := proj.readById(heatRef)

    // Cooling and heating off at midnight
    timestamp := DateTime.make( 2016, sys::Month.jan, 01, 00, 00 )
    value := false
    item := HisItem.make( timestamp,
                          value )
    his.write( coolRec, [item] )
    his.write( heatRec, [item] )

    // Cooling on at 11am
    timestamp = DateTime.make( 2016, sys::Month.jan, 01, 11, 00 )
    value = true
    item = HisItem.make( timestamp,
                         value )
    his.write( coolRec, [item] )

    // Heating on at 3pm
    timestamp = DateTime.make( 2016, sys::Month.jan, 01, 15, 00 )
    value = true
    item = HisItem.make( timestamp,
                         value )
    his.write( heatRec, [item] )

    // Cooling off at 5pm
    timestamp = DateTime.make( 2016, sys::Month.jan, 01, 17, 00 )
    value = false
    item = HisItem.make( timestamp,
                         value )
    his.write( coolRec, [item] )

    // Heating off at 7pm
    timestamp = DateTime.make( 2016, sys::Month.jan, 01, 19, 00 )
    value = false
    item = HisItem.make( timestamp,
                         value )
    his.write( heatRec, [item] )

    // Sync, otherwise his writes can fail as we shut down too quickly
    his.db.sync()
    proj.sync()


    date := Date.make(2016, Month.jan, 01)

    // Include extensions that provide necessary Axon functions
    addExtRec(ahuPerformanceAssessmentRulesExt::AhuPerformanceAssessmentRulesExt#) 
    addExtRec(hisKitExt::HisKitExt#) 
    
    context := makeSuContext()
    fn := context.evalToFunc("aparRule22")
    result := fn.call(context, [ahuRef, date])
    grid := (Grid)result

    // Check that there's exactly one window where the rule fires
    verifyEq( grid.size(), 1 ) 

    // Check that the window is from 3pm, for two hours
    Row row := grid.first()
    verifyEq( row["ts"], DateTime.make( 2016, sys::Month.jan, 01, 15, 00 ))
    verifyEq( row["v0"], Number.makeDuration(2hr) )


    // The day after, everything should be back to normal, no sparks
    date = Date.make(2016, Month.jan, 02)
    result = fn.call(context, [ahuRef, date])
    grid = (Grid)result

    // Check that there's exactly one window where the rule fires
    verifyEq( grid.size(), 0 )
  }


  @DbTest
  Void testSparkWhenHeatingAndCoolingOnBasicNumericModel()
  {
    addExtRec(hisExt::HisExt#)
    his := (HisExt)proj.ext("his")
    
    refs := createBasicNumericModel(proj)
    ahuRef := refs["ahuRef"]
    coolRef := refs["coolRef"]
    heatRef := refs["heatRef"]
    coolRec := proj.readById(coolRef)
    heatRec := proj.readById(heatRef)

    // Cooling and heating off at midnight
    timestamp := DateTime.make( 2016, sys::Month.jan, 01, 00, 00 )
    value := Number.make(0f, null)
    item := HisItem.make( timestamp,
                          value )
    his.write( coolRec, [item] )
    his.write( heatRec, [item] )

    // Cooling on at 11:07am
    timestamp = DateTime.make( 2016, sys::Month.jan, 01, 11, 07 )
    value = Number.make(75f, null) // %
    item = HisItem.make( timestamp,
                         value )
    his.write( coolRec, [item] )

    // Heating on at 3:23pm
    timestamp = DateTime.make( 2016, sys::Month.jan, 01, 15, 23 )
    value = Number.make(30f, null) // %
    item = HisItem.make( timestamp,
                         value )
    his.write( heatRec, [item] )

    // Cooling off at 5:54pm
    timestamp = DateTime.make( 2016, sys::Month.jan, 01, 17, 54 )
    value = Number.make(0f, null) // %
    item = HisItem.make( timestamp,
                         value )
    his.write( coolRec, [item] )

    // Heating off at 7:01pm
    timestamp = DateTime.make( 2016, sys::Month.jan, 01, 19, 01 )
    value = Number.make(0f, null) // %
    item = HisItem.make( timestamp,
                         value )
    his.write( heatRec, [item] )

    // Sync, otherwise his writes can fail as we shut down too quickly
    his.db.sync()
    proj.sync()


    date := Date.make(2016, Month.jan, 01)

    // Include extensions that provide necessary Axon functions
    addExtRec(ahuPerformanceAssessmentRulesExt::AhuPerformanceAssessmentRulesExt#) 
    addExtRec(hisKitExt::HisKitExt#) 
    
    context := makeSuContext()
    fn := context.evalToFunc("aparRule22")
    result := fn.call(context, [ahuRef, date])
    grid := (Grid)result

    // Check that there's exactly one window where the rule fires
    verifyEq( grid.size(), 1 ) 

    // Check that the window is from 15:23pm till 17:54 (two hours, 31 mins)
    Row row := grid.first()
    verifyEq( row["ts"], DateTime.make( 2016, sys::Month.jan, 01, 15, 23 ))
    verifyEq( row["v0"], Number.makeDuration(2hr + 31min) )


    // The day after, everything should be back to normal, no sparks
    date = Date.make(2016, Month.jan, 02)
    result = fn.call(context, [ahuRef, date])
    grid = (Grid)result

    // Check that there's exactly one window where the rule fires
    verifyEq( grid.size(), 0 )
  }


  @DbTest
  Void testSparkWhenHeatingAndCoolingOnMultiStageModel()
  {
    addExtRec(hisExt::HisExt#)
    his := (HisExt)proj.ext("his")
    
    refs := createMultiStageModel(proj)

    // Extract refs
    ahuRef := refs["ahuRef"]
    coolRef1 := refs["coolRef1"]
    coolRef2 := refs["coolRef2"]
    heatRef1 := refs["heatRef1"]
    heatRef2 := refs["heatRef2"]

    // Extract records
    coolRec1 := proj.readById(coolRef1)
    coolRec2 := proj.readById(coolRef2)
    heatRec1 := proj.readById(heatRef1)
    heatRec2 := proj.readById(heatRef2)

    // Cooling and heating off at midnight
    timestamp := DateTime.make( 2016, sys::Month.jan, 01, 00, 00 )
    value := false
    item := HisItem.make( timestamp,
                          value )
    his.write( coolRec1, [item] )
    his.write( coolRec2, [item] )
    his.write( heatRec1, [item] )
    his.write( heatRec2, [item] )

    // Set the histories of cool1, cool2, heat1, and heat2 to all possible
    // combinations of on and off; one state per hour.
    for (i:=1; i<16; ++i) {
      // Timestamp
      timestamp = DateTime.make( 2016, sys::Month.jan, 01, i, 00 )

      // Write values
      cool1 := (i.and(1) == 1)
      his.write( coolRec1, [ HisItem.make( timestamp, cool1 ) ])
      cool2 := (i.and(2) == 2)
      his.write( coolRec2, [ HisItem.make( timestamp, cool2 ) ])
      heat1 := i.and(4) == 4
      his.write( heatRec1, [ HisItem.make( timestamp, heat1 ) ])
      heat2 := i.and(8) == 8
      his.write( heatRec2, [ HisItem.make( timestamp, heat2 ) ])
    }

    // Set cool1, cool2, heat1, and heat2 to false at 16:00
    timestamp = DateTime.make( 2016, sys::Month.jan, 01, 16, 00 )
    item = HisItem.make( timestamp, false )
    his.write( coolRec1, [item] )
    his.write( coolRec2, [item] )
    his.write( heatRec1, [item] )
    his.write( heatRec2, [item] )


    // Sync, otherwise his writes can fail as we shut down too quickly
    his.db.sync()
    proj.sync()


    date := Date.make(2016, Month.jan, 01)

    // Include extensions that provide necessary Axon functions
    addExtRec(ahuPerformanceAssessmentRulesExt::AhuPerformanceAssessmentRulesExt#) 
    addExtRec(hisKitExt::HisKitExt#) 
    
    context := makeSuContext()
    fn := context.evalToFunc("aparRule22")
    result := fn.call(context, [ahuRef, date])
    grid := (Grid)result

    // Check that there's exactly three windows where the rule fires
    verifyEq( grid.size(), 3 ) 
    // Check the first window
    row := grid.get(0)
    verifyEq( row["ts"], DateTime.make( 2016, sys::Month.jan, 01, 05, 00 ))
    verifyEq( row["v0"], Number.makeDuration(3hr) )

    // Check the second window
    row = grid.get(1)
    verifyEq( row["ts"], DateTime.make( 2016, sys::Month.jan, 01, 09, 00 ))
    verifyEq( row["v0"], Number.makeDuration(3hr) )

    // Check the third window
    row = grid.get(2)
    verifyEq( row["ts"], DateTime.make( 2016, sys::Month.jan, 01, 13, 00 ))
    verifyEq( row["v0"], Number.makeDuration(3hr) )


    // The day after, everything should be back to normal, no sparks
    date = Date.make(2016, Month.jan, 02)
    result = fn.call(context, [ahuRef, date])
    grid = (Grid)result

    // Check that there's exactly one window where the rule fires
    verifyEq( grid.size(), 0 )
  }



// THESE NEED TO BE UNCOMMENTED ONCE MODEL TESTING IS IMPLEMENTED
  @DbTest
  Void testBasicModelIsComplete()
  {
    ahuRef := createBasicModel(proj)["ahuRef"]
    verifyEq(AhuPerformanceAssessmentRulesLib.testModel(ahuRef, proj), null)
  }


  @DbTest
  Void testBasicNumericModelIsComplete()
  {
    ahuRef := createBasicNumericModel(proj)["ahuRef"]
    verifyEq(AhuPerformanceAssessmentRulesLib.testModel(ahuRef, proj), null)
  }


  @DbTest
  Void testMultiStageModelIsComplete()
  {
    ahuRef := createMultiStageModel(proj)["ahuRef"]
    verifyEq(AhuPerformanceAssessmentRulesLib.testModel(ahuRef, proj), null)
  }

}

