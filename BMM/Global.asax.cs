using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Security;
using System.Web.SessionState;
using System.Configuration;
using System.Text;
using System.Net.Mail;
using InfiniedgeLibrary.ExceptionHandling;


namespace BMM
{
    public class Global : GlobalBase
    {
        #region + Private Properties

        #region XMLPath

        private string XMLPath
        {
            get
            {
                string retval = ConfigurationManager.AppSettings["XMLPath"];
                if (retval == null)
                {
                    throw new Exception("Missing XMLPath key from web.config.");
                }
                return retval;
            }
        }

        #endregion

        #region ErrorEmailFromAddress

        private string ErrorEmailFromAddress
        {
            get
            {
                string retval = ConfigurationManager.AppSettings["ErrorEmailFromAddress"];
                if (retval == null)
                {
                    throw new Exception("Missing ErrorEmailFromAddress key from web.config.");
                }
                return retval;
            }
        }

        #endregion

        #region ErrorEmailToAddress

        private string ErrorEmailToAddress
        {
            get
            {
                string retval = ConfigurationManager.AppSettings["ErrorEmailToAddress"];
                if (retval == null)
                {
                    throw new Exception("Missing ErrorEmailToAddress key from web.config.");
                }
                return retval;
            }
        }

        #endregion

        #region ErrorEmailSubject

        private string ErrorEmailSubject
        {
            get
            {
                string retval = ConfigurationManager.AppSettings["ErrorEmailSubject"];
                if (retval == null)
                {
                    throw new Exception("Missing ErrorEmailSubject key from web.config.");
                }
                return retval;
            }
        }

        #endregion

        #region SMTPServer

        private string SMTPServer
        {
            get
            {
                string retval = ConfigurationManager.AppSettings["SMTPServer"];
                if (retval == null)
                {
                    throw new Exception("Missing SMTPServer key from web.config.");
                }
                return retval;
            }
        }

        #endregion

        #endregion

        protected void Application_Start(object sender, EventArgs e)
        {

        }

        protected void Session_Start(object sender, EventArgs e)
        {

        }

        protected void Application_BeginRequest(object sender, EventArgs e)
        {

        }

        protected void Application_AuthenticateRequest(object sender, EventArgs e)
        {

        }

        protected void Application_Error(object sender, EventArgs e)
        {
          
            List<AdditionalInformation> AdditionalInfo = new List<AdditionalInformation>();
            HttpSessionState session = Session;
            System.Collections.Specialized.NameObjectCollectionBase.KeysCollection keys = session.Keys;       
    
            if (keys.Count == 0)
            {
                HandleError(null, ConfigurationManager.AppSettings["DevEmailUsers"], ConfigurationManager.AppSettings["ErrorEmailFromAddress"], new string[] { ConfigurationManager.AppSettings["ErrorEmailToAddress"] },
                        ConfigurationManager.AppSettings["ErrorEmailSubject"], ConfigurationManager.AppSettings["SMTPServer"], "/Error.aspx", "/Error404.aspx");
            }
            else
            {
                foreach (string key in keys)
                {
                    AdditionalInformation a = new AdditionalInformation(key, session[key].ToString());
                    AdditionalInfo.Add(a);
                }
                HandleError(AdditionalInfo, ConfigurationManager.AppSettings["DevEmailUsers"], ConfigurationManager.AppSettings["ErrorEmailFromAddress"], new string[] { ConfigurationManager.AppSettings["ErrorEmailToAddress"] },
                        ConfigurationManager.AppSettings["ErrorEmailSubject"], ConfigurationManager.AppSettings["SMTPServer"], "/Error.aspx", "/Error404.aspx");
            }
            
            //    // append session variables
            //    try
            //    {
            //        HttpSessionState session = Session;
            //        System.Collections.Specialized.NameObjectCollectionBase.KeysCollection keys = session.Keys;
            //        errMsg.AppendLine("SESSION VARIABLES");
            //        if (keys.Count == 0)
            //        {
            //            errMsg.AppendLine("None");
            //        }
            //        else
            //        {
            //            foreach (string key in keys)
            //            {
            //                errMsg.AppendLine(key + ": " + session[key]);
            //            }
            //        }
            //    }
            //    catch { }

            //    // create the message
            //    MailMessage msg = new MailMessage();
            //    msg.From = new MailAddress(ErrorEmailFromAddress);
            //    String to = DevEmail.GetErrorEmailAddress(Server.MapPath(XMLPath) + "Devs.xml", System.Environment.MachineName.ToUpper(), ErrorEmailToAddress);
            //    msg.To.Add(to);
            //    msg.Subject = ErrorEmailSubject;
            //    msg.Body = errMsg.ToString();

            //    // send the email
            //    SmtpClient client = new SmtpClient(SMTPServer);
            //    client.Send(msg);
            //}
            //catch { }
            //if (!Request.RawUrl.ToLower().Contains("Error.aspx"))
            //{
            //    Response.Redirect("/Error.aspx", true);
            //}
        }

        protected void Session_End(object sender, EventArgs e)
        {

        }

        protected void Application_End(object sender, EventArgs e)
        {

        }
    }
}