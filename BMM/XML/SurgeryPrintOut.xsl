<?xml version="1.0" encoding="utf-8" ?>

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <xsl:template match="/Details">
    <html>
      <head>
        <style text="text/css">
          *, th, td, p { font-size:10pt; }
          h1 { margin: 0; font-size:12pt; text-align:center }
          h2 { margin: 0; font-size:12pt; text-align:center; font-weight:normal }
          th, td { vertical-align:top; }
          th { padding-right:5px; font-weight: normal; }
          th.Center, th.Right { padding-left:25px; }
          table { margin:5px 0 0 0 }
          p { margin:5px 0 0 0 }
          hr { margin:8px 0 3px 0; padding:0; border:none; border-bottom:1px solid #000; height:0; line-height:0 }
          hr.Inner { border-bottom:1px solid #999; width: 75% }
          table.Payments th, table.Payments td { padding-top:5px }
          table.Summary { margin:10px 0 5px 0 }
          table.Summary td { vertical-align:middle }
          td.Label { text-align:left; padding:5px 0 0 0; width: 600px }
          td.Operator { font-size:12pt; font-weight: bold; text-align:center; width:20px }
          td.Value { text-align:right; padding:5px 0 0 0; width:75px }
          td.Underline { border-bottom:1px solid #000; padding-bottom:3px }
          tr.First th, tr.First td { padding-top:0 }
        </style>
      </head>
      <body>
        <h1>
          <xsl:value-of select="Company/LongName" />
        </h1>
        <h2>
          <xsl:value-of select="Company/Address" />
          <br/>
          <xsl:value-of select="Company/CityStateZip" />
          <br/>
          <br/>
          Phone: <xsl:value-of select="Company/Phone" />
          <br/>
          Fax: <xsl:value-of select="Company/Fax" />
          <br/>
          Federal ID # <xsl:value-of select="Company/FederalID" />
        </h2>
        <!-- BASIC INVOICE INFO -->
        <table cellspacing="0" cellpadding="0">
          <tbody>
            <tr>
              <th class="Left">Date:</th>
              <td>
                <xsl:value-of select="Date"/>
              </td>
            </tr>
          </tbody>
        </table>
        <table cellspacing="0" cellpadding="0">
          <tbody>
            <tr>
              <th class="Left">Invoice&#160;Number:</th>
              <td>
                <xsl:if test="InvoiceID">
                  <xsl:value-of select="InvoiceID"/>
                </xsl:if>
                <xsl:if test="not(InvoiceID)">_____________</xsl:if>
              </td>
            </tr>
          </tbody>
        </table>
        <xsl:if test="Attorney">
          <br/>
          <table cellspacing="0" cellpadding="0">
            <tbody>
              <tr>
                <th class="Left">Attorney:</th>
                <td>
                  <xsl:value-of select="Attorney/Name"/>
                </td>
              </tr>
            </tbody>
          </table>
          <table cellspacing="0" cellpadding="0">
            <tbody>
              <tr>
                <th class="Left">Address:</th>
                <td>
                  <xsl:value-of select="Attorney/Street1"/>
                  <br/>
                  <xsl:if test="Attorney/Street2">
                    <xsl:value-of select="Attorney/Street2"/>
                    <br/>
                  </xsl:if>
                  <xsl:value-of select="Attorney/City"/>,&#160;<xsl:value-of select="Attorney/State"/>&#160;<xsl:value-of select="Attorney/ZipCode"/>
                </td>
              </tr>
            </tbody>
          </table>
        </xsl:if>
        <br/>
        <table cellspacing="0" cellpadding="0">
          <tbody>
            <tr>
              <th class="Left">Patient:</th>
              <td>
                <xsl:if test="PatientName">
                  <xsl:value-of select="PatientName"/>
                </xsl:if>
                <xsl:if test="not(PatientName)">_____________</xsl:if>
              </td>
            </tr>
          </tbody>
        </table>
        <table cellspacing="0" cellpadding="0">
          <tbody>
            <tr>
              <th class="Left">Date&#160;of&#160;Accident:</th>
              <td>
                <xsl:if test="DateOfAccident">
                  <xsl:value-of select="DateOfAccident"/>
                </xsl:if>
                <xsl:if test="not(DateOfAccident)">_____________</xsl:if>
              </td>
            </tr>
          </tbody>
        </table>
        <hr/>
        <!-- SURGERIES INFO -->
        <table cellspacing="0" cellpadding="0">
          <tbody>
            <tr>
              <th class="Left">
                Procedure<xsl:if test="count(Procedures/Name) > 1">s</xsl:if>:
              </th>
              <td>
                <xsl:for-each select="Procedures/Name">
                  <xsl:if test="position() > 1">
                    <br/>
                  </xsl:if>
                  <xsl:value-of select="."/>
                </xsl:for-each>
              </td>
            </tr>
          </tbody>
        </table>
        <table cellspacing="0" cellpadding="0">
          <tbody>
            <tr>
              <th class="Left">
                Date<xsl:if test="count(Procedures/Date) > 1">s</xsl:if>&#160;of&#160;Procedure<xsl:if test="count(Procedures/Name) > 1">s</xsl:if>:
              </th>
              <td>
                <xsl:for-each select="Procedures/Date">
                  <xsl:if test="position() > 1">
                    <br/>
                  </xsl:if>
                  <xsl:value-of select="."/>
                </xsl:for-each>
              </td>
            </tr>
          </tbody>
        </table>
        <hr/>
        <!-- PROVIDER INFO -->
        <xsl:for-each select="Providers/Provider">
          <table cellspacing="0" cellpadding="0">
            <tbody>
              <tr>
                <th class="Left">Provider:</th>
                <td>
                  <xsl:value-of select="Name"/>
                </td>
              </tr>
            </tbody>
          </table>
          <table cellspacing="0" cellpadding="0">
            <tbody>
              <xsl:for-each select="Cost">
                <xsl:if test="position() = 1">
                  <tr class="First">
                    <td class="Label">
                        Cost of Procedure<xsl:if test="count(../Cost) > 1">s</xsl:if>:
                    </td>
                    <td class="Operator"></td>
                    <td class="Value">
                      <xsl:value-of select="."/>
                    </td>
                  </tr>
                </xsl:if>
                <xsl:if test="position() > 1">
                  <tr>
                    <td class="Label"></td>
                    <td class="Operator">+</td>
                    <td class="Value">
                      <xsl:value-of select="."/>
                    </td>
                  </tr>
                </xsl:if>
              </xsl:for-each>
              <tr>
                <td class="Label">Discount&#160;to&#160;our&#160;Attorneys:</td>
                <td class="Operator Underline">-</td>
                <td class="Value Underline">
                  <xsl:value-of select="TotalPPODiscount"/>
                </td>
              </tr>
              <tr>
                <td class="Label">
                  <xsl:value-of select="Name"/>&#160;Total:</td>
                <td class="Operator">-</td>
                <td class="Value">
                  <xsl:value-of select="Total"/>
                </td>
              </tr>
            </tbody>
          </table>
          <hr class="Inner"/>
        </xsl:for-each>
        <!-- SUMMARY -->
        <table cellspacing="0" cellpadding="0" class="Summary">
          <tr class="First">
            <td class="Label">Total&#160;Charges:</td>
            <td class="Operator"></td>
            <td class="Value">
              <xsl:value-of select="TotalCostMinusPPODiscounts" />
            </td>
          </tr>
          <tr>
            <td class="Label">Deposit&#160;Received:</td>
            <td class="Operator">-</td>
            <td class="Value">
              <xsl:value-of select="DepositPaid" />
            </td>
          </tr>
          <tr>
            <td class="Label">Principal&#160;Received:</td>
            <td class="Operator">-</td>
            <td class="Value">
              <xsl:value-of select="PrincipalPaid" />
            </td>
          </tr>
          <tr>
            <td class="Label">Additional&#160;Deductions:</td>
            <td class="Operator">-</td>
            <td class="Value">
              <xsl:value-of select="AdditionalDeductions" />
            </td>
          </tr>
          <tr>
            <td class="Label">Cumulative&#160;Service&#160;Fee:</td>
            <td class="Operator">+</td>
            <td class="Value">
              <xsl:value-of select="CumulativeServiceFee" />
            </td>
          </tr>
          <tr>
            <td class="Label">Cumulative&#160;Service&#160;Fee&#160;Received:</td>
            <td class="Operator Underline">-</td>
            <td class="Value Underline">
              <xsl:value-of select="ServiceFeeReceived" />
            </td>
          </tr>
          <tr>
            <td class="Label">
              <b>Balance&#160;Due:</b>
            </td>
            <td class="Operator"></td>
            <td class="Value">
              <b>
                <xsl:value-of select="EndingBalance" />
              </b>
            </td>
          </tr>
        </table>
        <!-- PAYMENT COMMENTS -->
        <!--<xsl:if test="count(Comments/Comment) > 0">
          <hr/>
          <p>Payment Comments</p>
          <xsl:for-each select="Comments/Comment">
            <table cellspacing="0" cellpadding="0">
              <tbody>
                <tr>
                  <th class="Left">
                    <xsl:value-of select="Date"/>&#160;-
                  </th>
                  <td>
                    <xsl:call-template name="break">
                      <xsl:with-param name="text" select="Text" />
                    </xsl:call-template>
                  </td>
                </tr>
              </tbody>
            </table>
          </xsl:for-each>
        </xsl:if>-->
      </body>
    </html>
  </xsl:template>

  <xsl:template name="break">
    <xsl:param name="text" select="."/>
    <xsl:choose>
      <xsl:when test="contains($text, '&#xa;')">
        <xsl:value-of select="substring-before($text, '&#xa;')"/>
        <br/>
        <xsl:call-template name="break">
          <xsl:with-param name="text" select="substring-after($text, '&#xa;')" />
        </xsl:call-template>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="$text"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

</xsl:stylesheet>