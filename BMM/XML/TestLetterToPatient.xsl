<?xml version="1.0" encoding="utf-8" ?>

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <xsl:template match="/Details">
    <html>
      <head>
        <style text="text/css">
          strong { display: inline-block; padding-right: 5px;}
          th, td { vertical-align: top; }
          th { padding-right: 5px; }
          table { margin: 5px 0 0 45px; }
          table table { margin: 0; }
          p { margin: 10px 0 0 45px; }
          body { font-family: arial; font-size:14px;  }
          <!--.t { padding-top:75px;margin-top:0px;margin-bottom:0px; }-->
        </style>
      </head>
      <body>
        <!--<p class="t"></p>-->
        <p style="padding-top:120px"><xsl:value-of select="Date"/></p>
        <p style="padding-top:40px">
          <xsl:value-of select="Patient/FirstName"/>&#160;<xsl:value-of select="Patient/LastName"/>
          <br/>
          <xsl:value-of select="Patient/Street1"/>
          <br/>
          <xsl:if test="Patient/Street2">
            <xsl:value-of select="Patient/Street2"/>
            <br/>
          </xsl:if>
          <xsl:value-of select="Patient/City"/>&#160;<xsl:value-of select="Patient/State"/>,&#160;<xsl:value-of select="Patient/ZipCode"/>
        </p>
        <p style="padding-top:40px">Dear <xsl:value-of select="Patient/FirstName"/>&#160;<xsl:value-of select="Patient/LastName"/>:</p>
        <br/>
        <p>This is to confirm that we have scheduled for you the below diagnostic test:</p>
        <table cellpadding="0" cellspacing="0">
          <tr>
            <th>Procedure:</th>
            <td>
              <xsl:if test="Test/Name">
                <xsl:value-of select="Test/Name"/>
              </xsl:if>
              <xsl:if test="not(Test/Name)">_____________________</xsl:if>
            </td>
          </tr>
        </table>
        <table cellpadding="0" cellspacing="0">
          <tr>
            <th>Date:</th>
            <td>
              <xsl:if test="Test/Date">
                <xsl:value-of select="Test/Date"/>
              </xsl:if>
              <xsl:if test="not(Test/Date)">_____________________</xsl:if>
            </td>
          </tr>
        </table>
        <table cellpadding="0" cellspacing="0">
          <tr>
            <th>Time:</th>
            <td>
              <xsl:if test="Test/Time">
                <xsl:value-of select="Test/Time"/>
              </xsl:if>
              <xsl:if test="not(Test/Time)">_____________________</xsl:if>
            </td>
          </tr>
        </table>
        <table cellpadding="0" cellspacing="0">
          <tr>
            <th>Location:</th>
            <td>
              <xsl:value-of select="Provider/Name"/>
            </td>
          </tr>
        </table>
        <table cellpadding="0" cellspacing="0">
          <tr>
            <th>Address:</th>
            <td>
              <xsl:value-of select="Provider/Street1"/>,&#160;<xsl:if test="Provider/Street2">
                <xsl:value-of select="Provider/Street2"/>,&#160;
              </xsl:if><xsl:value-of select="Provider/City"/>,&#160;<xsl:value-of select="Provider/State"/>&#160;<xsl:value-of select="Provider/ZipCode"/>
            </td>
          </tr>
        </table>
        <br/>
        <p>
          Please be there promptly, or if there is some difficulty, contact our office immediately. This procedure, as well as any of our other services
          that are necessary for your attorney to handle your claim and/or lawsuit, is being funded by our company on behalf of your attorney,
          <xsl:if test="Attorney">
            <xsl:value-of select="Attorney/FirstName"/>&#160;<xsl:value-of select="Attorney/LastName"/>
          </xsl:if><xsl:if test="not(Attorney)">_____________________</xsl:if>, in connection with your accident dated
        <xsl:if test="DateOfAccident"><xsl:value-of select="DateOfAccident"/></xsl:if><xsl:if test="not(DateOfAccident)">_____________________</xsl:if>.
        </p>
        <p>
          Our services include not only arranging for the procedure, but also paying for it, and handling and securing the medical bills, reports,
          and other procedures that your attorney requires.
        </p>
        <p>
          In the event you should change attorneys or your mailing address, you must notify us immediately so our records can be updated. Our
          policy calls for us to contact you from time to time, requesting the status of your claim or lawsuit.
        </p>
        <p>
          For identification purposes, a valid I.D. must be presented upon arrival at the facility. Also, if an instruction sheet is attached,
          please bring it with you. If you have any questions, feel free to call me at <xsl:value-of select="Company/Phone"/>. Thank you for
          utilizing our services.
        </p>
        <br/>
        <p>Very Truly Yours,</p>
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