1. Add the ExceptionHandling project to the solution
2. Create a reference to the ExceptionHandling project.
3. Create an XML file formatted as follows:

  <?xml version="1.0" encoding="utf-8" ?> 
  <Users>
  	  <User Email="john@infiniedge.com" MachineName="3THLSC1" /> 
  	  <User Email="blewis@infiniedge.com" MachineName="8KK9BB1" /> 
	  <User Email="johnathon@infiniedge.com" MachineName="JD19BB1" /> 
	  <User Email="wade@infiniedge.com" MachineName="9K071F1" /> 
	  <User Email="latham@infiniedge.com" MachineName="8G19BB1" /> 
	  <User Email="terry@infiniedge.com" MachineName="36NJ1D1" /> 
	  <User Email="adam.ainsworth@infiniedge.com" MachineName="H88B7C1" /> 
	  <User Email="emccardle@infiniedge.com" MachineName="BF19BB1" /> 
	  <User Email="scott@infiniedge.com" MachineName="DZ9YHF1" /> 
	  <User Email="chad@infiniedge.com" MachineName="H5NJ1D1" /> 
  </Users>

4. Put this XML file anywhere within the project.
5. Inherit GloableBase from the project's Global.asax
6. Call HandleError



Sample web.config:

<?xml version="1.0"?>
<configuration>
  <configSections>
    <section name="ErrorEmailSettings" type="InfiniedgeLibrary.ExceptionHandling.Classes.ErrorEmailConfigurationSection, InfiniedgeLibrary.ExceptionHandling"/>
  </configSections>
  <ErrorEmailSettings SmtpServer="inf-mail01.infiniedge.com" Subject="Error in APSO" FromAddress="testing@infiniedge.com" ToAddresses="testing@infiniedge.com" DevUsersXmlPath="\App_Data\Devs.xml" />
  <system.web>
        <compilation debug="true" targetFramework="4.0" />
  </system.web>

</configuration>
