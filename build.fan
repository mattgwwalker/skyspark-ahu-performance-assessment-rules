#! /usr/bin/env fan
//
// Copyright (c) 2016, Direct Control
// All Rights Reserved
//
// History:
//   18 Feb 16   Matthew Walker   Creation
//

using build

**
** Build: ahuPerformanceAssessmentRulesExt
**
class Build : BuildPod
{
  new make()
  {
    podName = "ahuPerformanceAssessmentRulesExt"
    summary = "Implementation of NIST AHU Performance Assessment Rules (APAR)"
    version = Version("0.1")
    meta    = ["org.name":        "Direct Control",
               "org.uri":         "http://www.directcontrol.co.nz/",
	       "proj.name":       "SkySpark", // Required for Fantom documentation
               "license.name":    "GPL 3.0",
               "skyspark.docExt": "true",     // Documentation of Axon/Tags
               "skyspark.doc":    "true"]     // Fantom documentation
    depends = ["sys 1.0",
               "haystack 2.1",
               "proj 2.1",
	       "hisExt 2.1",
	       "hisKitExt 2.1",
	       "concurrent 1.0",
	       "util 1.0"]
    srcDirs = [`fan/`,
               `test/`]
    resDirs = [`locale/`,
               `lib/`,
	       `res/`,
	       `res/img/`]
    index   =
    [
      "proj.ext": "ahuPerformanceAssessmentRulesExt::AhuPerformanceAssessmentRulesExt",
      "proj.lib": "ahuPerformanceAssessmentRulesExt::AhuPerformanceAssessmentRulesLib",
    ]
  }
}
