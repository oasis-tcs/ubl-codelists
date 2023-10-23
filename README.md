# README

Members of the [Universal Business Language Technical Committee](https://www.oasis-open.org/committees/ubl/) create and manage technical content in this TC GitHub repository (https://github.com/oasis-tcs/ubl-codelists/) as part of the TC's chartered work (the program of work and deliverables described in its [charter](https://www.oasis-open.org/committees/ubl/charter.php).

OASIS TC GitHub repositories, as described in [GitHub Repositories for OASIS TC Members' Chartered Work](https://www.oasis-open.org/resources/tcadmin/github-repositories-for-oasis-tc-members-chartered-work), are governed by the OASIS [TC Process](https://www.oasis-open.org/policies-guidelines/tc-process), [IPR Policy](https://www.oasis-open.org/policies-guidelines/ipr), and other policies. While they make use of public GitHub repositories, these repositories are distinct from [OASIS Open Repositories](https://www.oasis-open.org/resources/open-repositories), which are used for development of open source [licensed](https://www.oasis-open.org/resources/open-repositories/licenses) content.

## Description

Members of the OASIS Universal Business Language (UBL) TC use this TC GitHub repository as part of the TC's chartered work in the development of the UBL Standard. The UBL distribution includes a suite of example code lists, obtained from international sources maintained by code list custodians. This repository is used periodically to harvest the external sources of code lists and transform their content into the OASIS Standard genericode format for use in the UBL distribution. The resulting files are dropped into the UBL repository for use in creating the UBL distribution.

The initial version of this repository is recreated from working code 2020-04-17 that appears no longer to work properly. But it is recorded in the git repository as a matter of record and new development will be based on this base.

The current version of this repository appears not to run successfully from GitHub because one of the sources refuses to supply the data content, returning an HTTP 403 error. This error is not returned when running the process from one's shell command line.

Accordingly, the workflow actions are disabled and the repository must be run locally. The debugging of the server-based execution was halted since it wasn't going to be used as long as data was being withheld by the data maintenance agency.

## Invocation

The creation of the results is triggered by the `build.sh` file run as follows in a shell environment:

- `sh build.sh  {target-directory-name}  {"local"}  {YYYYMMDD-HHMMz}`

The target directory must not be a subdirectory of the git repository, or the repository files may get tainted.

The string "`local`" distinguishes execution from the server's use of a different string for server behaviours. 

Any label can be used as the third argument, but the timestamp label will help when publishing the results for posting in Kavi.

This is an example execution that works with the supplied example file:

- `sh build.sh ~/t/results local test`

### Dependencies

The process relies on the following to be in the execution environment:

- OpenOffice available as `soffice` on the command line path
- HTML Tidy available as `tidy` on the command line path

## Master control file

The process control is governed by the values found in a master configuration file that is wired for a particular release (version and stage) of UBL. The name of the master file must be of the form:

- `master-code-list-UBL-{2.x}-{stage}.xml`

... where `x` is the subversion of UBL 2, and the stage is something along the lines of `csprd01`, `cs02`, etc. Note that once the code lists are retrieved for a given version of UBL 2.x and the package is voted on, this process of creating code lists probably should not be run again as it would change the files that had been accepted at one point.

There are two environment variables in `build.sh` that dictate which configuration file is used (see examples in next section):

````
export UBLversion={2.x}
export UBLstage={stage}
````

The configuration file format is as follows:

````
<lists>
  <list outuri="{genericode-output-file}.gc" method="{method-of-list-access}"
        inuri="{target-local-file-from-source-alternative-format-location-uri}"
        reviewuri="{uri-for-human-review-of-">
   <!--the list identification metadata for the output genericode follows-->        
   <Identification>
      <ShortName>AllowanceChargeReasonCode</ShortName>
      <LongName xml:lang="en">Allowance Charge Reason Code</LongName>
      <LongName Identifier="listID">UN/EDIFACT EDED 5189</LongName>
      <Version>18B</Version>
      <CanonicalUri>urn:oasis:names:specification:ubl:codelist:gc:AllowanceChargeReasonCode</CanonicalUri>
      <CanonicalVersionUri>urn:oasis:names:specification:ubl:codelist:gc:AllowanceChargeReasonCode:2.3</CanonicalVersionUri>
      <LocationUri>http://docs.oasis-open.org/ubl/os-UBL-2.3/cl/gc/default/AllowanceChargeReasonCode-2.3.gc</LocationUri>
      <AlternateFormatLocationUri MimeType="text/xml">jar:http://www.unece.org/fileadmin/DAM/uncefact/xml_schemas/D19B.zip!/uncefact/codelist/standard/UNECE_AllowanceChargeReasonCode_D19A.xsd</AlternateFormatLocationUri>
      <Agency>
         <LongName xml:lang="en">United Nations Economic Commission for Europe</LongName>
         <Identifier Identifier="http://www.unece.org/trade/untdid/d18a/tred/tred3055.htm">6</Identifier>
      </Agency>
   </Identification>
  </list>
  <list ...

````
The `Crane-list2ant.xsl` stylesheet reads the configuration/control file and synthesizes the Apache Ant script needed to be executed to obtain and massage the list contents into the result set of genericode files.

There are eight methods processed by the stylesheet:

- `method="Copy"`
  - the `raw/` directory has a hand-written genericode file that is copied into the target directory as is (the configuration/control  
- `method="Country"`
  - how to massage the known source of country codes
- `method="Currency"`
  - how to massage the known source of currency codes
- `method="Language"`
  - how to massage the known source of language codes
- `method="Mime"`
  - how to massage the known source of MIME type codes
- `method="Packaging"`
  - how to massage the known source of packaging codes
- `method="Unit"`
  - how to massage the known source of units of measure codes
- `method="XSD"`
  - how to massage the known source of codes expressed as XSD enumerations

## An example working release

Included in the repository is `master-code-list-UBL-2.3-csprd03.xml` that, at this time of writing, appears to be working without error and is recreating the code lists used in UBL 2.3 (modulo updates to the real-time lists that have happened since then).

The `build.sh` file needs to be modified as follows (these are not supplied on the command line because they change so very rarely):

````
export UBLversion=2.3
export UBLstage=csprd03
````
Using:

- `sh build.sh ~/t/results local test`

... the process creates two zip files for uploading to Kavi:

- `codelists-UBL-2.3-csprd03-test-archive-only.zip`
- `codelists-UBL-2.3-csprd03-test.zip`

## Preparing a new release

There are four real-time code lists:

- binary object MIME codes
- country identification cdoes
- currency codes
- language codes

There are five code lists that are snapshot in time, requiring the configuration/control file to specify the particular snapshot source of data that is retrieved:

- allowance charge codes
- channel codes
- packaging type codes
- payment means codes
- transport equipment type codes
- unit of measure codes

Each list has a `reviewuri=""` attribute that offers the maintainer of the configuration/control file a location for their review of the data available, but not necessarily the data itself. This is meant to guide the operator in the setting of actual retrieval values in other attributes and elements. It may be that, over time, the expression of the code list values changes. This will necessitate changing the code to accommodate the new expression.

Each list has a `<Verison>` element that needs to be reviewed carefully by the maintainer and set based on their research done at review time. In a number of fields in the genericode identification metadata, the keyword string `$VERSION` is replaced by the XSLT stylesheet with the version extracted from the source data. Other `<version>` strings need to be hand-edited.

Each list has a reference to the agency's identifier found in this list:

 - `https://service.unece.org/trade/untdid/d18a/tred/tred3055.htm`

... but that list changes over time. Using hunt and peck, change the '`d18a`' to be the combination of the letter '`d`', two digits of the year, and then either '`a`' or '`b`' for the first or second release of that year. Eventually you will find the latest release of that list and can make the changes.

## Contributions

As stated in this repository's [CONTRIBUTING](https://github.com/oasis-tcs/ubl-codelists/blob/main/CONTRIBUTING.md) file, contributors to this repository must be Members of the OASIS UBL TC for any substantive contributions or change requests.  Anyone wishing to contribute to this GitHub project and [participate](https://www.oasis-open.org/join/participation-instructions) in the TC's technical activity is invited to join as an OASIS TC Member. Public feedback is also accepted, subject to the terms of the [OASIS Feedback License](https://www.oasis-open.org/policies-guidelines/ipr#appendixa). 

## Licensing

Please see the [LICENSE](https://github.com/oasis-tcs/ubl-codelists/blob/main/LICENSE.md) file for description of the license terms and OASIS policies applicable to the TC's work in this GitHub project. Content in this repository is intended to be part of the UBL TC's permanent record of activity, visible and freely available for all to use, subject to applicable OASIS policies, as presented in the repository [LICENSE](https://github.com/oasis-tcs/ubl-codelists/blob/main/LICENSE.md). 

## Further Description of this Repository

*Any narrative content may be provided here by the TC, for example, if the Members wish to provide an extended statement of purpose.*

## Contact

Please send questions or comments about [OASIS TC GitHub repositories](https://www.oasis-open.org/resources/tcadmin/github-repositories-for-oasis-tc-members-chartered-work) to the [OASIS TC Administrator](mailto:tc-admin@oasis-open.org).  For questions about content in this repository, please contact the TC Chair or Co-Chairs as listed on the the UBL TC's [home page](https://www.oasis-open.org/committees/ubl/).
