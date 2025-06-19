<?xml version="1.0" encoding="utf-8" ?>

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <xsl:template match="/Details">
    <html>
      <head>
        <style text="text/css">
          strong { display: inline-block; padding-right: 5px;}
          th, td { vertical-align: top; }
          th { padding-right: 5px; }
          table { margin: 5px 0 }
          table table { margin: 0; }
          p { margin: 10px 0; }
          .t { padding-top:150px;margin-top:0px;margin-bottom:0px; }
        </style>
      </head>
      <body>
        <p class="t"></p>
        <table cellpadding="0" cellspacing="0">
          <tr>
            <th>To:</th>
            <td>
              <xsl:value-of select="Provider/Name"/>
            </td>
          </tr>
        </table>
        <p>
          BY THESE PRESENTS <xsl:value-of select="Company/LongName"/> ("<xsl:value-of select="Company/Name"/>"), hereby authorizes your facility to
          provide the designated medical services to the individual identified herein in accordance with the terms of our guaranty of payment to your facility.
        </p>
        <br/>
        <table cellpadding="0" cellspacing="0" width="100%">
          <tr>
            <td align="left" width="50%">
              <table cellpadding="0" cellspacing="0">
                <tr>
                  <th>Name:</th>
                  <td>
                    <xsl:value-of select="Patient/FirstName"/>&#160;<xsl:value-of select="Patient/LastName"/>
                  </td>
                </tr>
              </table>
            </td>
            <td align="right" width="50%">
              <table cellpadding="0" cellspacing="0">
                <tr>
                  <th>Phone:</th>
                  <td>
                    <xsl:value-of select="Patient/Phone"/>
                  </td>
                </tr>
              </table>
            </td>
          </tr>
        </table>
        <table cellpadding="0" cellspacing="0">
          <tr>
            <th valign="top">Address:</th>
            <td>
              <xsl:value-of select="Patient/Street1"/>
              <br/>
              <xsl:if test="Patient/Street2 != ''">
                <xsl:value-of select="Patient/Street2"/>
                <br/>
              </xsl:if>
              <xsl:value-of select="Patient/City"/>&#160;<xsl:value-of select="Patient/State"/>,&#160;<xsl:value-of select="Patient/ZipCode"/>
            </td>
          </tr>
        </table>
        <table cellpadding="0" cellspacing="0" width="100%">
          <tr>
            <td align="left">
              <table cellpadding="0" cellspacing="0">
                <tr>
                  <th>SSN:</th>
                  <td>
                    <xsl:if test="string-length(Patient/SSN) > 0">
                      <xsl:value-of select="Patient/SSN"/>
                    </xsl:if>
                    <xsl:if test="string-length(Patient/SSN) = 0">____________</xsl:if>
                  </td>
                </tr>
              </table>
            </td>
            <td align="center">
              <table cellpadding="0" cellspacing="0">
                <tr>
                  <th>Date of Birth:</th>
                  <td>
                    <xsl:value-of select="Patient/DateOfBirth"/>
                  </td>
                </tr>
              </table>
            </td>
            <td align="right">
              <table cellpadding="0" cellspacing="0">
                <tr>
                  <th>Date of Accident:</th>
                  <td>
                    <xsl:if test="DateOfAccident">
                      <xsl:value-of select="DateOfAccident"/>
                    </xsl:if>
                    <xsl:if test="not(DateOfAccident)">__________</xsl:if>
                  </td>
                </tr>
              </table>
            </td>
          </tr>
        </table>
        <br/>

        <div class="Tests">
          <xsl:for-each select="Tests/Test">
            <div class="Test">
              <table cellpadding="0" cellspacing="0">
                <tr>
                  <th>Test:</th>
                  <td>
                    <xsl:value-of select="Name"/>
                  </td>
                </tr>
              </table>
              <xsl:if test="position() = 1">
                <table cellpadding="0" cellspacing="0">
                  <tr>
                    <th>Physician:</th>
                    <td>
                      <xsl:value-of select="../../Physician/FirstName"/>&#160;<xsl:value-of select="../../Physician/LastName"/>
                    </td>
                  </tr>
                </table>
                <xsl:if test="../../Physician/Contacts">
                  <table cellpadding="0" cellspacing="0">
                    <tr>
                      <th>Contacts:</th>
                      <td>
                        <xsl:for-each select="../../Physician/Contacts/Contact">
                          <xsl:if test="position() > 1">
                            <br/>
                          </xsl:if>
                          <xsl:value-of select="Name"/>,&#160;<xsl:value-of select="Position"/>
                          <xsl:if test="Phone">,&#160;<xsl:value-of select="Phone"/></xsl:if>
                        </xsl:for-each>
                      </td>
                    </tr>
                  </table>
                </xsl:if>
              </xsl:if>
              <xsl:if test="Date">
                <table cellpadding="0" cellspacing="0">
                  <tr>
                    <th>Date of Test:</th>
                    <td>
                      <xsl:value-of select="Date"/>
                    </td>
                  </tr>
                </table>
              </xsl:if>
              <xsl:if test="Time">
                <table cellpadding="0" cellspacing="0">
                  <tr>
                    <th>Time:</th>
                    <td>
                      <xsl:value-of select="Time"/>
                    </td>
                  </tr>
                </table>
              </xsl:if>
            </div>
          </xsl:for-each>
        </div>

        <p>
          We have also enclosed a copy of a medical authorization to provide our company with copies of the medical report(s) and bill(s) that
          are generated as a result of rendering these services to the patient.  Please forward the report(s) and bill(s) on the standard billing form(s) to
          <xsl:value-of select="Company/Address"/>,&#160;<xsl:value-of select="Company/CityStateZip"/>.
          If possible, please notify our office by phone at
          <xsl:value-of select="Company/Phone"/>
          that this patient has not arrived for the appointment so that we can make any additional arrangement as may be necessary.
        </p>
        <p>
          Attached is a prescription from the attending physician of the patient, setting forth the diagnostic procedures to be performed by you.
        </p>
        <br/>
        <p>
          ____________________________, Louisiana, this _________________ day of ______________, 20______.
        </p>
        <br/>
        <p>Thank you very much,</p>
          <br/>
          <br/>
          <br/>
        <p>
          <xsl:value-of select="User/FirstName"/>&#160;<xsl:value-of select="User/LastName"/>
          <br/>
          <xsl:value-of select="User/Position"/>
        </p>
      </body>
    </html>
  </xsl:template>

</xsl:stylesheet>