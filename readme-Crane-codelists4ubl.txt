readme-Crane-codelists4ubl.txt  2017-09-25 23:30z

This is an Ant-based environment for obtaining code lists resources and
converting them into genericode format.

This environment runs as a shell script:

    sh make-UBL-code-lists.sh {stage} {dateTimeUTC} {dateTimeLocal}
    
as in:

    sh make-UBL-code-lists.sh csd02wd02 20170913-1450z 20170913-1050

During development one can use:

    sh make-UBL-code-lists.sh {stage} test now

The crux of the transform is the metadata management file, the example
include is:

   master-code-list-UBL-2.2-csd02wd02.xml

There is the following dependency on the execution path:

  - "office" needs to invoke LibreOffice

The make-UBL-code-lists.sh file must be modified to change the JAR path
directories to include:

  - Apache Ant
  - Saxon XSLT processor
  - xjparse validation tool 

The directories are used as follows:

  - package - where the final results are produced
  - work - where intermediate files are placed
  - doc - where the stylesheet documentation files are found
  - raw - where manually-obtained files are placed

=============================

Copyright (C) - Crane Softwrights Ltd.
              - http://www.CraneSoftwrights.com/links/res-dev.htm

Redistribution and use in source and binary forms, with or without
 modification, are permitted provided that the following conditions are met:

1. Redistributions of source code must retain the above copyright notice,
 this list of conditions and the following disclaimer.

2. Redistributions in binary form must reproduce the above copyright notice,
this list of conditions and the following disclaimer in the documentation 
and/or other materials provided with the distribution.

3. Neither the name of the copyright holder nor the names of its contributors 
may be used to endorse or promote products derived from this software without 
specific prior written permission.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" 
AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE 
IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE 
ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE 
LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR 
CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF 
SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS 
INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN 
CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) 
ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE 
POSSIBILITY OF SUCH DAMAGE.


Note: for your reference, the above is the "BSD-3-Clause license"; this text
      was obtained 2017-07-24 at https://opensource.org/licenses/BSD-3-Clause

THE COPYRIGHT HOLDERS MAKE NO REPRESENTATION ABOUT THE SUITABILITY OF THIS
CODE FOR ANY PURPOSE.
