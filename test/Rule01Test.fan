/*
  Copyright 2016 Matthew Walker, Direct Control
  
  This program is free software: you can redistribute it and/or modify
  it under the terms of the GNU General Public License as published by
  the Free Software Foundation, either version 3 of the License, or
  (at your option) any later version.
  
  This program is distributed in the hope that it will be useful,
  but WITHOUT ANY WARRANTY; without even the implied warranty of
  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
  GNU General Public License for more details.
  
  You should have received a copy of the GNU General Public License
  along with this program.  If not, see <http://www.gnu.org/licenses/>.
  
  History:
    2016-02-18   Matthew Walker   Creation
    2016-04-22   Matthew Walker   Added GPLv3 license
*/

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

