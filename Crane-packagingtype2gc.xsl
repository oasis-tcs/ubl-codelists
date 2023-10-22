<?xml version="1.0" encoding="US-ASCII"?>
<?xml-stylesheet type="text/xsl" href="../xslstyle/xslstyle-docbook.xsl"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:xs="http://www.CraneSoftwrights.com/ns/xslstyle"
                xmlns:xsd="http://www.w3.org/2001/XMLSchema"
                xmlns:c="urn:X-Crane"
                xmlns:office="urn:oasis:names:tc:opendocument:xmlns:office:1.0"
                xmlns:table="urn:oasis:names:tc:opendocument:xmlns:table:1.0"
                xmlns:text="urn:oasis:names:tc:opendocument:xmlns:text:1.0"  
                xmlns:config="urn:oasis:names:tc:opendocument:xmlns:config:1.0"
                exclude-result-prefixes="xs xsd c office table text config"
                version="2.0">

<xsl:import href="Crane-common4codelists.xsl"/>

<xs:doc info="$Id: Crane-packagingtype2gc.xsl,v 1.4 2017/09/23 13:51:17 admin Exp $"
        filename="Crane-packagingtype2gc.xsl" vocabulary="DocBook">
  <xs:title>Convert packaging types XML to genericode</xs:title>
  <para>
    Convert an instance of packaging codes ODS XML converted from
    <ulink
url="jar:https://www.unece.org/fileadmin/DAM/cefact/recommendations/rec21/rec21.zip!/rec21_Rev9e_2012.xls"
>jar:https://www.unece.org/fileadmin/DAM/cefact/recommendations/rec21/rec21.zip!/rec21_Rev9e_2012.xls</ulink>
    to OASIS genericode using metadata supplied by the list of lists.
  </para>
  <programlisting>
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
</programlisting>
</xs:doc>

<!--========================================================================-->
<xs:doc>
  <xs:title>Main logic for columns and rows</xs:title>
  <para>
    The input is raw XML from the source of packaging codes
  </para>
</xs:doc>

<xs:template>
  <para>
    Create the columns and rows as needed.
  </para>
  <xs:param name="filtered">
    <para>
      Indication that the columns and rows are to be filtered.  For this
      code list filtering is done based on the presence of the word
      "DEPRECATED" in the name value
    </para>
  </xs:param>
</xs:template>
<xsl:template name="c:columnsAndRows">
  <xsl:param name="filtered" as="xsd:boolean" select="false()"/>
  <xsl:variable name="tableOfPackagingTypes"
               select="/office:document-content/office:body/office:spreadsheet/
                       table:table[@table:name='Annex V and VI']"/>
  <xsl:if test="empty($tableOfPackagingTypes)">
    <xsl:message terminate="yes"
                 select="'Expected table not found in input',
                         document-uri(/)"/>
  </xsl:if>
   <ColumnSet>
      <Column Id="status" Use="optional">
         <ShortName>Status</ShortName>
         <Data Type="normalizedString" Lang="en"/>
      </Column>
      <Column Id="code" Use="required">
         <ShortName>Code</ShortName>
         <Data Type="normalizedString" Lang="en"/>
      </Column>
      <Column Id="name" Use="required">
         <ShortName>Name</ShortName>
         <Data Type="string" Lang="en"/>
      </Column>
      <Column Id="description" Use="optional">
         <ShortName>Description</ShortName>
         <Data Type="string" Lang="en"/>
      </Column>
      <Column Id="numericcode" Use="required">
         <ShortName>NumericCode</ShortName>
         <Data Type="string"/>
      </Column>
      <Key Id="codeKey">
         <ShortName>CodeKey</ShortName>
         <ColumnRef Ref="code"/>
      </Key>
   </ColumnSet>
  <SimpleCodeList>
    <xsl:for-each select="
      $tableOfPackagingTypes/table:table-row[position()>3]
      [c:cellValue(table:table-cell[c:columnNumbers(.)=2]) and
       c:cellValue(table:table-cell[c:columnNumbers(.)=3])]
      [not($filtered) or
       c:cellValue(table:table-cell[c:columnNumbers(.)=1])!='X']">
      <Row>
        <Value ColumnRef="code">
           <SimpleValue>
             <xsl:value-of
                 select="c:cellValue(table:table-cell[c:columnNumbers(.)=2])"/>
           </SimpleValue>
        </Value>
        <Value ColumnRef="name">
           <SimpleValue>
             <xsl:value-of
                 select="c:cellValue(table:table-cell[c:columnNumbers(.)=3])"/>
           </SimpleValue>
        </Value>
        <xsl:for-each
       select="c:cellValue(table:table-cell[c:columnNumbers(.)=4])[string(.)]">
          <Value ColumnRef="description">
             <SimpleValue>
               <xsl:value-of select="."/>
             </SimpleValue>
          </Value>
        </xsl:for-each>
        <Value ColumnRef="numericcode">
           <SimpleValue>
             <xsl:value-of
                 select="c:cellValue(table:table-cell[c:columnNumbers(.)=5])"/>
           </SimpleValue>
        </Value>
      </Row>
   </xsl:for-each>
  </SimpleCodeList>
</xsl:template>

</xsl:stylesheet>
