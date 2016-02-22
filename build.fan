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
    summary = "TODO: summary of pod name..."
    version = Version("1.0")
    meta    = [
                "org.name":     "Direct Control",
                //"org.uri":      "http://acme.com/",
                //"proj.name":    "Project Name",
                //"proj.uri":     "http://acme.com/product/",
                "license.name": "Commercial",
              ]
    depends = ["sys 1.0",
               "haystack 2.1",
               "proj 2.1"]
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
