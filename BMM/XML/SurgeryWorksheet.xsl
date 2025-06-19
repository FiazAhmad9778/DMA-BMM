<?xml version="1.0" encoding="utf-8" ?>

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <xsl:template match="/Details">
    <html>
      <head>
        <style text="text/css">
          * { font-size:10pt; }
          h1 { margin: 0 0 5px 0; font-size:12pt; text-align:center; }
          th, td { vertical-align:top; text-align:left }
          th { padding-right:5px; font-weight: normal; }
          th.Center, th.Right { padding-left:25px; }
          table { margin:0 0 5px 0 }
          p { margin:0 0 5px 0 }
          hr { margin:3px 0 8px 0; padding:0; border:none; border-bottom:1px solid #000; height:0; line-height:0 }
          hr.Inner { border-bottom:1px solid #999; }
          hr.SummaryInner { border-bottom:1px solid #999; width:75% }
          table.Payments th, table.Payments td { padding-top:3px; padding-bottom:2px }
          table.Comment td.Border { border-bottom:1px solid #000 }
          table.SummaryLeft { float:left; }
          table.SummaryRight { float:left; margin-left:50px }
          td.Label, td.Operator, td.Value { padding:5px 0 0 0; }
          td.Label { vertical-align:middle }
          td.Operator { vertical-align:middle; text-align:center; font-size:12pt; font-weight: bold; padding:0 5px }
          td.Value { vertical-align:middle; text-align: right; }
          td.Underline { border-bottom:1px solid #000; padding-bottom: 5px; }
          table.SummaryRight td.Value { padding-left:15px }
        </style>
      </head>
      <body>
        <h1><xsl:value-of select="CompanyName"  /> WORKSHEET</h1>
        <!-- BASIC INVOICE INFO -->
        <table cellspacing="0" cellpadding="0">
          <tbody>
            <tr>
              <th class="Left">Invoice&#160;Number:</th>
              <td>
                <xsl:if test="InvoiceID"><xsl:value-of select="InvoiceID"/></xsl:if>
                <xsl:if test="not(InvoiceID)">_____________</xsl:if>
              </td>
            </tr>
          </tbody>
        </table>
        <table cellspacing="0" cellpadding="0">
          <tbody>
            <tr>
              <th class="Left">Invoice&#160;Type:</th>
              <td>
                <xsl:value-of select="Type" />
              </td>
              <th class="Center">Status:</th>
              <td>
                <xsl:value-of select="Status"/>
              </td>
              <th class="Right">Complete:</th>
              <td>
                <xsl:value-of select="Complete"/>
              </td>
            </tr>
          </tbody>
        </table>
        <br/>
        <!-- PATIENT INFO -->
        <table cellspacing="0" cellpadding="0">
          <tbody>
            <tr>
              <th class="Left">Patient&#160;Name:</th>
              <td>
                <b>
                  <xsl:value-of select="Patient/Name"/>
                </b>
              </td>
            </tr>
          </tbody>
        </table>
        <table cellspacing="0" cellpadding="0">
          <tbody>
            <tr>
              <th class="Left">SSN:</th>
              <td>
                <xsl:if test="Patient/SSN">
                  <xsl:value-of select="Patient/SSN"/>
                </xsl:if>
                <xsl:if test="not(Patient/SSN)">_____________</xsl:if>
              </td>
              <th class="Center">Phone:</th>
              <td>
                <xsl:value-of select="Patient/Phone"/>
              </td>
              <th class="Right">Date&#160;of&#160;Birth:</th>
              <td>
                <xsl:value-of select="Patient/DateOfBirth"/>
              </td>
            </tr>
          </tbody>
        </table>
        <table cellspacing="0" cellpadding="0">
          <tbody>
            <tr>
              <th class="Left">Address:</th>
              <td>
                <xsl:value-of select="Patient/Street1"/>
                <br/>
                <xsl:if test="Patient/Street2">
                  <xsl:value-of select="Patient/Street2"/>
                  <br/>
                </xsl:if>
                <xsl:value-of select="Patient/City"/>,&#160;<xsl:value-of select="Patient/State"/>&#160;<xsl:value-of select="Patient/ZipCode"/>
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
        <!-- ATTORNEY INFO -->
        <xsl:if test="Attorney">
          <hr/>
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
                <th class="Left">Firm:</th>
                <td>
                  <xsl:if test="Attorney/FirmName">
                    <xsl:value-of select="Attorney/FirmName"/>
                  </xsl:if>
                  <xsl:if test="not(Attorney/FirmName)">_____________</xsl:if>
                </td>
                <th class="Center">Phone:</th>
                <td>
                  <xsl:value-of select="Attorney/Phone"/>
                </td>
                <th class="Right">Fax:</th>
                <td>
                  <xsl:if test="Attorney/Fax">
                    <xsl:value-of select="Attorney/Fax"/>
                  </xsl:if>
                  <xsl:if test="not(Attorney/Fax)">_____________</xsl:if>
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
          <xsl:if test="count(Attorney/Contacts/Contact) > 0">
            <table cellspacing="0" cellpadding="0">
              <tbody>
                <tr>
                  <th class="Left">
                    Contact<xsl:if test="count(Attorney/Contacts/Contact) > 1">s</xsl:if>:
                  </th>
                  <td>
                    <xsl:for-each select="Attorney/Contacts/Contact">
                      <xsl:if test="position() > 1"><br/></xsl:if>
                      <xsl:value-of select="Name"/>,&#160;<xsl:value-of select="Position"/><xsl:if test="Phone">,&#160;<xsl:value-of select="Phone"/></xsl:if>
                    </xsl:for-each>
                  </td>
                </tr>
              </tbody>
            </table>
          </xsl:if>
        </xsl:if>
        <!-- PHYSICIAN INFO -->
        <xsl:if test="Physician">
          <hr/>
          <table cellspacing="0" cellpadding="0">
            <tbody>
              <tr>
                <th class="Left">Physician:</th>
                <td>
                  <xsl:value-of select="Physician/Name"/>
                </td>
              </tr>
            </tbody>
          </table>
          <table cellspacing="0" cellpadding="0">
            <tbody>
              <tr>
                <th class="Left">Phone:</th>
                <td>
                  <xsl:value-of select="Physician/Phone"/>
                </td>
                <th class="Right">Fax:</th>
                <td>
                  <xsl:if test="Physician/Fax">
                    <xsl:value-of select="Physician/Fax"/>
                  </xsl:if>
                  <xsl:if test="not(Physician/Fax)">_____________</xsl:if>
                </td>
              </tr>
            </tbody>
          </table>
          <table cellspacing="0" cellpadding="0">
            <tbody>
              <tr>
                <th class="Left">Address:</th>
                <td>
                  <xsl:value-of select="Physician/Street1"/>
                  <br/>
                  <xsl:if test="Physician/Street2">
                    <xsl:value-of select="Physician/Street2"/>
                    <br/>
                  </xsl:if>
                  <xsl:value-of select="Physician/City"/>,&#160;<xsl:value-of select="Physician/State"/>&#160;<xsl:value-of select="Physician/ZipCode"/>
                </td>
              </tr>
            </tbody>
          </table>
        </xsl:if>
        <!-- SURGERY INFO -->
        <xsl:for-each select="Surgeries/Surgery">
          <xsl:if test="position() = 1">
            <hr/>
          </xsl:if>
          <xsl:if test="position() > 1">
            <hr class="Inner"/>
          </xsl:if>
          <table cellspacing="0" cellpadding="0">
            <tbody>
              <tr>
                <th class="Left">Surgery&#160;Type:</th>
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
                  <th class="Left">Notes&#160;on&#160;Procedure:</th>
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
                <th class="Left">Date<xsl:if test="count(Dates/Date) > 1">s</xsl:if>&#160;Scheduled:</th>
                <td>
                  <xsl:for-each select="Dates/Date">
                    <xsl:if test="position() > 1">
                      <br/>
                    </xsl:if>
                    <xsl:value-of select="." />
                  </xsl:for-each>
                </td>
                <th class="Right">
                  <xsl:value-of select="InOutPatient"/>
                </th>
              </tr>
            </tbody>
          </table>
        </xsl:for-each>
        <!-- PROVIDER INFO -->
        <xsl:for-each select="Providers/Provider">
          <xsl:if test="position() = 1">
            <hr/>
          </xsl:if>
          <xsl:if test="position() > 1">
            <hr class="Inner"/>
          </xsl:if>
          <table cellspacing="0" cellpadding="0">
            <tbody>
              <tr>
                <th class="Left">Provider:</th>
                <td>
                  <b>
                    <xsl:value-of select="Name"/>
                  </b>
                </td>
              </tr>
            </tbody>
          </table>
          <table cellspacing="0" cellpadding="0">
            <tbody>
              <tr>
                <th class="Left">Phone:</th>
                <td>
                  <xsl:value-of select="Phone"/>
                </td>
                <th class="Center">Fax:</th>
                <td>
                  <xsl:if test="Fax">
                    <xsl:value-of select="Fax"/>
                  </xsl:if>
                  <xsl:if test="not(Fax)">_____________</xsl:if>
                </td>
                <th class="Right">Abbreviation:</th>
                <td>
                  <xsl:if test="Abbreviation">
                    <xsl:value-of select="Abbreviation"/>
                  </xsl:if>
                  <xsl:if test="not(Abbreviation)">_____________</xsl:if>
                </td>
              </tr>
            </tbody>
          </table>
          <table cellspacing="0" cellpadding="0">
            <tbody>
              <tr>
                <th class="Left">Address:</th>
                <td>
                  <xsl:value-of select="Street1"/>
                  <br/>
                  <xsl:if test="Street2">
                    <xsl:value-of select="Street2"/>
                    <br/>
                  </xsl:if>
                  <xsl:value-of select="City"/>,&#160;<xsl:value-of select="State"/>&#160;<xsl:value-of select="ZipCode"/>
                </td>
              </tr>
            </tbody>
          </table>
          <xsl:if test="count(Services/Service) > 0">
            <table cellspacing="0" cellpadding="0" class="Payments">
              <tbody>
                <xsl:for-each select="Services/Service">
                  <tr>
                    <th class="Left">Cost:</th>
                    <td>
                      <xsl:value-of select="Cost"/>
                    </td>
                    <th class="Center">Amount&#160;Due:</th>
                    <td>
                      <xsl:value-of select="AmountDue"/>
                    </td>
                    <th class="Right">Due&#160;Date:</th>
                    <td>
                      <xsl:value-of select="DueDate"/>
                    </td>
                  </tr>
                </xsl:for-each>
              </tbody>
            </table>
          </xsl:if>
        </xsl:for-each>
        <!-- ATTORNEY PAYMENTS -->
        <xsl:if test="AttorneyPayments">
          <hr/>
          <p>Attorney Payment<xsl:if test="count(AttorneyPayments/Payment) > 1">s</xsl:if></p>
          <table cellspacing="0" cellpadding="0" class="Payments">
            <tbody>
              <xsl:for-each select="AttorneyPayments/Payment">
                <tr>
                  <th class="Left">Date:</th>
                  <td>
                    <xsl:value-of select="Date"/>
                  </td>
                  <th class="Center">Type:</th>
                  <td>
                    <xsl:value-of select="Type"/>
                  </td>
                  <th class="Center">Amount:</th>
                  <td>
                    <xsl:value-of select="Amount"/>
                  </td>
                  <th class="Right">Check&#160;No.:</th>
                  <td>
                    <xsl:value-of select="CheckNo"/>
                  </td>
                </tr>
              </xsl:for-each>
            </tbody>
          </table>
        </xsl:if>
        <!-- PROVIDER PAYMENTS -->
        <xsl:if test="ProviderPayments">
          <hr/>
          <p>Payment<xsl:if test="count(ProviderPayments/Payment) > 1">s</xsl:if> to Provider<xsl:if test="count(Providers/Provider) > 1">s</xsl:if></p>
          <table cellspacing="0" cellpadding="0" class="Payments">
            <tbody>
              <xsl:for-each select="ProviderPayments/Payment">
                <tr>
                  <th class="Left">Date:</th>
                  <td>
                    <xsl:value-of select="Date"/>
                  </td>
                  <th class="Center">Recipient:</th>
                  <td>
                    <xsl:value-of select="Recipient"/>
                  </td>
                  <th class="Center">Amount:</th>
                  <td>
                    <xsl:value-of select="Amount"/>
                  </td>
                  <th class="Right">Check&#160;No.:</th>
                  <td>
                    <xsl:value-of select="CheckNo"/>
                  </td>
                </tr>
              </xsl:for-each>
            </tbody>
          </table>
        </xsl:if>
        <!-- SUMMARY -->
        <hr/>
        <table cellspacing="0" cellpadding="0">
          <tbody>
            <tr>
              <th class="Left">Date&#160;Service&#160;Fee&#160;Begins:</th>
              <td>
                <xsl:if test="DateServiceFeeBegins">
                  <xsl:value-of select="DateServiceFeeBegins"/>
                </xsl:if>
                <xsl:if test="not(DateServiceFeeBegins)">_____________</xsl:if>
              </td>
              <th class="Right">Maturity&#160;Date:</th>
              <td>
                <xsl:if test="MaturityDate">
                  <xsl:value-of select="MaturityDate"/>
                </xsl:if>
                <xsl:if test="not(MaturityDate)">_____________</xsl:if>
              </td>
            </tr>
          </tbody>
        </table>
        <hr class="SummaryInner" />
        <table cellspacing="0" cellpadding="0"  class="SummaryLeft">
          <tbody>
            <tr>
              <td class="Label">Total&#160;Cost:</td>
              <td class="Operator"></td>
              <td class="Value">
                <xsl:value-of select="TotalCostMinusPPODiscounts"/>
              </td>
            </tr>
            <tr>
              <td class="Label">Principal/Deposits&#160;Recieved:</td>
              <td class="Operator">-</td>
              <td class="Value">
                <xsl:value-of select="PrincipalAndDepositPaid"/>
              </td>
            </tr>
            <tr>
              <td class="Label Underline">Additional&#160;Deductions:</td>
              <td class="Operator Underline">-</td>
              <td class="Value Underline">
                <xsl:value-of select="AdditionalDeductions"/>
              </td>
            </tr>
            <tr>
              <td class="Label">Balance&#160;Due:</td>
              <td class="Operator"></td>
              <td class="Value">
                <xsl:value-of select="BalanceDue"/>
              </td>
            </tr>
            <tr>
              <td class="Label">Losses&#160;Amount:</td>
              <td class="Operator">-</td>
              <td class="Value">
                <xsl:value-of select="LossesAmount"/>
              </td>
            </tr>
            <tr>
              <td class="Label">Service&#160;Fee&#160;Waived:</td>
              <td class="Operator">-</td>
              <td class="Value">
                <xsl:value-of select="ServiceFeeWaived"/>
              </td>
            </tr>
            <tr>
              <td class="Label Underline">Cumulative&#160;Svc.&#160;Fee:</td>
              <td class="Operator Underline">+</td>
              <td class="Value Underline">
                <xsl:value-of select="CumulativeServiceFee"/>
              </td>
            </tr>
            <tr>
              <td class="Label">Ending&#160;Balance:</td>
              <td class="Operator"></td>
              <td class="Value">
                <xsl:value-of select="EndingBalance"/>
              </td>
            </tr>
          </tbody>
        </table>
        <table cellspacing="0" cellpadding="0" class="SummaryRight">
          <tbody>
            <tr>
              <td class="Label">Total&#160;PPO:</td>
              <td class="Value">
                <xsl:value-of select="TotalPPODiscount"/>
              </td>
            </tr>
            <tr>
              <td class="Label">Cost&#160;of&#160;Goods&#160;Sold:</td>
              <td class="Value">
                <xsl:value-of select="CostOfGoodsSold"/>
              </td>
            </tr>
            <tr>
              <td class="Label">Revenue:</td>
              <td class="Value">
                <xsl:value-of select="TotalRevenue"/>
              </td>
            </tr>
          </tbody>
        </table>
        <!-- Payment Comments -->
        <div style="clear:both"></div>
        <hr></hr>
        <div style="margin-top:20px"></div>
        <table cellspacing="0" cellpadding="0" class="Comment">
          <tbody>
            <tr>
              <td class="Border">
                User
              </td>
              <td class="Border" style="padding-left:75px">
                Date &amp; Time
              </td>
              <td class="Border" style="padding-left:50px">
                Comment
              </td>
            </tr>
            <xsl:for-each select="Comments/Comment">
              <tr>
                <td>
                  <xsl:value-of select="User"/>
                </td>
                <td style="padding-left:75px">
                  <xsl:value-of select="Date"/>
                </td>
                <td style="padding-left:50px">
                  <xsl:value-of select="Text"/>
                </td>
              </tr>
            </xsl:for-each>
          </tbody>
        </table>
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