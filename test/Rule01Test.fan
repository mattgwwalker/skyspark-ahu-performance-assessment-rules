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
** 
**
class Rule01Test : ProjTest
{
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

}

