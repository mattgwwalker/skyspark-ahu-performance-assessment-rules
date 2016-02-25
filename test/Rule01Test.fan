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


}

