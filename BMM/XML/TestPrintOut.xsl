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
          table { margin:0 0 5px 0 }
          p { margin:0 0 5px 0 }
          hr { margin:3px 0 8px 0; padding:0; border:none; border-bottom:1px solid #000; height:0; line-height:0 }
          table.Payments th, table.Payments td { padding-bottom:5px }
          table.Summary { margin:5px 0 10px 0 }
          table.Summary td { vertical-align:middle }
          td.Label { text-align:left; padding:5px 20px 0 0 }
          td.Operator { font-size:12pt; font-weight: bold; padding:0 5px; text-align:center }
          td.Value { text-align:right; padding:5px 0 0 0 }
          td.Underline { border-bottom:1px solid #000; padding-bottom: 5px }
          table.Disclaimer { margin:15px 0 0 0; border:1px solid #000 }
          table.Disclaimer td { padding: 10px; }
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
        <!-- TEST INFO -->
        <xsl:if test="count(Tests/Test) > 0">
          <hr/>
        </xsl:if>
        <xsl:for-each select="Tests/Test">
          <xsl:if test="position() > 1">
            <br/>
          </xsl:if>
          <table cellspacing="0" cellpadding="0">
            <tbody>
              <tr>
                <th class="Left">Provider:</th>
                <td>
                  <xsl:if test="Provider">
                    <xsl:value-of select="Provider"/>
                  </xsl:if>
                  <xsl:if test="not(Provider)">_____________</xsl:if>
                </td>
              </tr>
            </tbody>
          </table>
          <table cellspacing="0" cellpadding="0">
            <tbody>
              <tr>
                <th class="Left">Test:</th>
                <td>
                  <xsl:if test="Name">
                    <xsl:value-of select="Name"/>
                  </xsl:if>
                  <xsl:if test="not(Name)">_____________</xsl:if>
                </td>
              </tr>
            </tbody>
          </table>
          <xsl:if test="Notes">
            <table cellspacing="0" cellpadding="0">
              <tbody>
                <tr>
                  <th class="Left">Notes&#160;on&#160;Test:</th>
                  <td>
                    <xsl:call-template name="break">
                      <xsl:with-param name="text" select="Notes" />
                    </xsl:call-template>
                  </td>
                </tr>
              </tbody>
            </table>
          </xsl:if>
          <table cellspacing="0" cellpadding="0">
            <tbody>
              <tr>
                <th class="Left">Test&#160;Date:</th>
                <td>
                  <xsl:if test="TestDate">
                    <xsl:value-of select="TestDate"/>
                  </xsl:if>
                  <xsl:if test="not(TestDate)">_____________</xsl:if>
                </td>
              </tr>
            </tbody>
          </table>
          <table cellspacing="0" cellpadding="0">
            <tbody>
              <tr>
                <th class="Left">Test&#160;Cost:</th>
                <td>
                  <xsl:value-of select="TestCost"/>
                </td>
              </tr>
            </tbody>
          </table>
        </xsl:for-each>
        <!-- SUMMARY -->
        <hr/>
        <center>
          <table cellspacing="0" cellpadding="0" class="Summary">
            <tr>
              <td class="Label">Charge:</td>
              <td class="Operator"></td>
              <td class="Value">
                <xsl:value-of select="TotalCost" />
              </td>
            </tr>
            <tr>
              <td class="Label Underline">
                Minus&#160;<xsl:value-of select="Company/Name"/>&#160;Discount:
              </td>
              <td class="Operator Underline">-</td>
              <td class="Value Underline">
                <xsl:value-of select="TotalPPODiscount" />
              </td>
            </tr>
            <tr>
              <td class="Label">New&#160;Balance:</td>
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
              <td class="Label Underline">Cumulative&#160;Service&#160;Fee&#160;Received:</td>
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
        </center>
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
        <!--<center>
          <table cellspacing="0" cellpadding="0" class="Disclaimer">
            <tr>
              <td>
                This is not a final invoice. Interest will accumulate accordingly. Please call for a final payout.
                <br/>
                <b>FOR YOUR RECORDS ONLY. PLEASE DO NOT DISTRIBUTE.</b>
              </td>
            </tr>
          </table>
        </center>-->
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