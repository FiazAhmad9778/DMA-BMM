<?xml version="1.0" encoding="utf-8" ?>

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <xsl:template match="/Details">
    <html>
      <head>
        <style text="text/css">
          * { font-size:11pt; line-height: 14pt }
          h1 { margin: 0 0 5px 0; font-size:14pt; text-align:center; }
          th, td { vertical-align:top; }
          th { padding-right:5px; font-weight: normal; }
          th.Center, th.Right { padding-left:25px; }
          table { margin:0 0 5px 0 }
          p { margin:0 0 5px 0 }
          hr { margin:3px 0 8px 0; padding:0; border:none; border-bottom:1px solid #000; height:0; line-height:0 }
          hr.Inner { border-bottom:1px solid #999; }
          table.Payments th, table.Payments td { padding-bottom:5px }                            
          table.Comment td.Border { border-bottom:1px solid #000 }
          div.Summary { text-align: center }
          table.Summary td.Label, table.Summary td.Value { width:100px }
          table.Summary td.Label { text-align:center; padding:0 5px 2px 5px }
          table.Summary td.Value { border:1px solid #000; text-align:right; padding:2px 5px }
          table.Summary td.Row2 { padding-top:10px }
          table.Summary td.Operator { font-size:14pt; font-weight: bold; padding:0 5px }
        </style>
      </head>
      <body>
        <h1>
          <xsl:value-of select="CompanyName"  /> WORKSHEET
        </h1>
        <!-- BASIC INVOICE INFO -->
        <table cellspacing="0" cellpadding="0">
          <tbody>
            <tr>
              <th class="Left">Invoice&#160;Number:</th>
              <td>
                <xsl:if test="InvoiceID">
                  <xsl:value-of select="InvoiceID"/>
                </xsl:if>
                <xsl:if test="not(InvoiceID)">____________</xsl:if>
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
                <xsl:if test="not(Patient/SSN)">____________</xsl:if>
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
                <xsl:if test="not(DateOfAccident)">____________</xsl:if>
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
                  <xsl:if test="not(Attorney/FirmName)">____________</xsl:if>
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
                  <xsl:if test="not(Attorney/Fax)">____________</xsl:if>
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
                      <xsl:if test="position() > 1">
                        <br/>
                      </xsl:if>
                      <xsl:value-of select="Name"/>,&#160;<xsl:value-of select="Position"/><xsl:if test="Phone">
                        ,&#160;<xsl:value-of select="Phone"/>
                      </xsl:if>
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
                  <xsl:if test="not(Physician/Fax)">____________</xsl:if>
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
        <!-- TEST INFO -->
        <xsl:for-each select="Tests/Test">
          <xsl:if test="position() = 1">
            <hr/>
          </xsl:if>
          <xsl:if test="position() > 1">
            <hr class="Inner"/>
          </xsl:if>
          <!-- PROVIDER INFO -->
          <xsl:if test="Provider">
            <table cellspacing="0" cellpadding="0">
              <tbody>
                <tr>
                  <th class="Left">Provider:</th>
                  <td>
                    <b>
                      <xsl:value-of select="Provider/Name"/>
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
                    <xsl:value-of select="Provider/Phone"/>
                  </td>
                  <th class="Right">Fax:</th>
                  <td>
                    <xsl:if test="Provider/Fax">
                      <xsl:value-of select="Provider/Fax"/>
                    </xsl:if>
                    <xsl:if test="not(Provider/Fax)">____________</xsl:if>
                  </td>
                </tr>
              </tbody>
            </table>
            <table cellspacing="0" cellpadding="0">
              <tbody>
                <tr>
                  <th>Address:</th>
                  <td>
                    <xsl:value-of select="Provider/Street1"/>
                    <br/>
                    <xsl:if test="Provider/Street2">
                      <xsl:value-of select="Provider/Street2"/>
                      <br/>
                    </xsl:if>
                    <xsl:value-of select="Provider/City"/>,&#160;<xsl:value-of select="Provider/State"/>&#160;<xsl:value-of select="Provider/ZipCode"/>
                  </td>
                </tr>
              </tbody>
            </table>
            <br/>
          </xsl:if>
          <table cellspacing="0" cellpadding="0">
            <tbody>
              <tr>
                <th class="Left">Test&#160;Name:</th>
                <td>
                  <xsl:if test="Name">
                    <b>
                      <xsl:value-of select="Name"/>
                    </b>
                  </xsl:if>
                  <xsl:if test="not(Name)">____________</xsl:if>
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
                  <xsl:if test="not(TestDate)">____________</xsl:if>
                </td>
                <th class="Center">Test&#160;Time:</th>
                <td>
                  <xsl:if test="TestTime">
                    <xsl:value-of select="TestTime"/>
                  </xsl:if>
                  <xsl:if test="not(TestTime)">____________</xsl:if>
                </td>
                <th class="Center">Test&#160;Results:</th>
                <td>
                  <xsl:if test="Result">
                    <xsl:value-of select="Result"/>
                  </xsl:if>
                  <xsl:if test="not(Result)">____________</xsl:if>
                </td>
                <th class="Right">Canceled:</th>
                <td>
                  <xsl:value-of select="Canceled"/>
                </td>
              </tr>
            </tbody>
          </table>
          <table cellspacing="0" cellpadding="0">
            <tbody>
              <tr>
                <th class="Left">Amount&#160;Due:</th>
                <td>
                  <xsl:value-of select="AmountDue"/>
                </td>
                <th class="Center">Due&#160;Date:</th>
                <td>
                  <xsl:value-of select="DueDate"/>
                </td>
                <th class="Right">Total&#160;Cost:</th>
                <td>
                  <xsl:value-of select="TotalCost"/>
                </td>
              </tr>
            </tbody>
          </table>
          <table cellspacing="0" cellpadding="0">
            <tbody>
              <tr>
                <th class="Left">Deposit&#160;to&#160;Provider:</th>
                <td>
                  <xsl:if test="DepositToProvider">
                    <xsl:value-of select="DepositToProvider"/>
                  </xsl:if>
                  <xsl:if test="not(DepositToProvider)">____________</xsl:if>
                </td>
                <th class="Center">Amount&#160;Paid&#160;to&#160;Provider:</th>
                <td>
                  <xsl:if test="AmountPaidToProvider">
                    <xsl:value-of select="AmountPaidToProvider"/>
                  </xsl:if>
                  <xsl:if test="not(AmountPaidToProvider)">____________</xsl:if>
                </td>
                <th class="Center">Date:</th>
                <td>
                  <xsl:if test="Date">
                    <xsl:value-of select="Date"/>
                  </xsl:if>
                  <xsl:if test="not(Date)">____________</xsl:if>
                </td>
                <th class="Right">Check&#160;No.:</th>
                <td>
                  <xsl:if test="CheckNo">
                    <xsl:value-of select="CheckNo"/>
                  </xsl:if>
                  <xsl:if test="not(CheckNo)">____________</xsl:if>
                </td>
              </tr>
            </tbody>
          </table>
        </xsl:for-each>
        <!-- ATTORNEY PAYMENTS -->
        <xsl:if test="Payments">
          <hr/>
          <p>Attorney Payments</p>
          <table cellspacing="0" cellpadding="0" class="Payments">
            <tbody>
              <xsl:for-each select="Payments/Payment">
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
        <!-- SUMMARY -->
        <hr/>
        <div class="Summary">
          <table cellspacing="0" cellpadding="0" class="Summary">
            <tr>
              <td></td>
              <td class="Label">Sum&#160;of&#160;Tests:</td>
              <td></td>
              <td class="Label">Principal/Deposit:</td>
              <td></td>
              <td class="Label">Add'l&#160;Deductions:</td>
              <td></td>
              <td class="Label">Balance&#160;Due:</td>
            </tr>
            <tr>
              <td class="Operator"></td>
              <td class="Value">
                <xsl:value-of select="TotalCostMinusPPODiscounts"/>
              </td>
              <td class="Operator">-</td>
              <td class="Value">
                <xsl:value-of select="PrincipalAndDepositPaid"/>
              </td>
              <td class="Operator">-</td>
              <td class="Value">
                <xsl:value-of select="AdditionalDeductions"/>
              </td>
              <td class="Operator">=</td>
              <td class="Value">
                <xsl:value-of select="BalanceDue"/>
              </td>
            </tr>
            <tr>
              <td></td>
              <td class="Label Row2">Service&#160;Fees:</td>
              <td></td>
              <td class="Label Row2">Sum&#160;of&#160;Losses:</td>
              <td></td>
              <td class="Label Row2">Svc.&#160;Fee&#160;Waived:</td>
              <td></td>
              <td class="Label Row2">Ending&#160;Balance:</td>
            </tr>
            <tr>
              <td class="Operator">+</td>
              <td class="Value">
                <xsl:value-of select="ServiceFeeReceived"/>
              </td>
              <td class="Operator">-</td>
              <td class="Value">
                <xsl:value-of select="LossesAmount"/>
              </td>
              <td class="Operator">-</td>
              <td class="Value">
                <xsl:value-of select="ServiceFeeWaived"/>
              </td>
              <td class="Operator">=</td>
              <td class="Value">
                <xsl:value-of select="EndingBalance"/>
              </td>
            </tr>
          </table>
        </div>
        <!-- Payment Comments -->           
        <hr></hr>
        <div style="margin-top:20px"></div>
        <table cellspacing="0" cellpadding="0" class="Comment">
          <tbody>
            <tr>
              <td class="Border">                
                  User              
              </td>
              <td class="Border" style="padding-left:25px">                
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
                <td style="padding-left:25px">
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