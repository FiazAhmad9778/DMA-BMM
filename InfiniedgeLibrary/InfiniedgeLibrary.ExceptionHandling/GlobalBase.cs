using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Web;
using System.Net.Mail;
using InfiniedgeLibrary.ExceptionHandling.Classes;

namespace InfiniedgeLibrary.ExceptionHandling
{
    public class GlobalBase : System.Web.HttpApplication
    {
        #region HandleError

        public void HandleError(List<AdditionalInformation> AdditionalInfo = null, string ErrorPageURL = "/Error.aspx", string Error404PageURL = "/Error.aspx", string ErrorRefCode = "")
        {
            HandleError(new ErrorEmailSettings(), AdditionalInfo, ErrorPageURL, Error404PageURL, ErrorRefCode);
        }

        public void HandleError(IErrorEmailSettings settings, List<AdditionalInformation> AdditionalInfo = null, string ErrorPageURL = "/Error.aspx", string Error404PageURL = "/Error.aspx", string ErrorRefCode = "")
        {
            HandleError(AdditionalInfo, settings.DevUsersXmlPath, settings.FromAddress, settings.ToAddresses.ToArray(), settings.Subject, settings.SmtpServer, ErrorPageURL, Error404PageURL, ErrorRefCode);
        }

        /// <summary>
        /// Method to handle the error in a graceful and consistent manner.
        /// </summary>
        /// <param name="AdditionalInfo">List of keys/values to display along with the rest of the normal error information.</param>
        /// <param name="DevUsersXMLPath">Path to the Devs xml file</param>
        /// <param name="ErrorEmailFromAddress">Email address the error is from</param>
        /// <param name="ErrorEmailToAddresses">Array of email addresses the email is to go to (unless the machine is in the devs xml file)</param>
        /// <param name="ErrorEmailSubject">Subject of the error message.</param>
        /// <param name="SMTPServer">SMTP Server to use</param>
        /// <param name="ErrorPageURL">Optional - error page path (defaults to /error.aspx)</param>
        /// <param name="Error404PageURL">Optional - error page path for 404 errors (defaults to /error.aspx)</param>
        public void HandleError(List<AdditionalInformation> AdditionalInfo, string DevUsersXMLPath, string ErrorEmailFromAddress, string[] ErrorEmailToAddresses, string ErrorEmailSubject, string SMTPServer, string ErrorPageURL = "/Error.aspx", string Error404PageURL = "/Error.aspx", string ErrorRefCode = "")
        {
            Exception exception = Server.GetLastError();

            if (exception == null || HandleHttpError(exception, Error404PageURL, true) ||
                HandleViewStateError(exception))
            {
                Response.Redirect(ErrorPageURL, true);
                return;
            }

            // create the email
            var mailMsg = new MailMessage()
            {
                From = new MailAddress(ErrorEmailFromAddress),
                Subject = ErrorEmailSubject,
                Body = GenerateErrorEmail(exception, AdditionalInfo, ErrorRefCode)
            };
            // add the to addresses
            foreach (string email in GetErrorEmailAddresses(DevUsersXMLPath, Environment.MachineName.ToUpper(), ErrorEmailToAddresses))
            {
                mailMsg.To.Add(email);
            }
            // send the email
            new SmtpClient(SMTPServer).Send(mailMsg);

            //redirect to the error page and pass the reference code as a query string
            if (ErrorRefCode != null && ErrorRefCode.Length > 0)
                Response.Redirect(ErrorPageURL + "?ref=" + ErrorRefCode);
            else
                Response.Redirect(ErrorPageURL);
        }

        /// <summary>
        /// Method to handle the error in a graceful and consistent manner.
        /// </summary>
        /// <param name="AdditionalInfo">List of keys/values to display along with the rest of the normal error information.</param>
        /// <param name="DevUsersXMLPath">Path to the Devs xml file</param>
        /// <param name="ErrorEmailFromAddress">Email address the error is from</param>
        /// <param name="ErrorEmailToAddresses">Array of email addresses the email is to go to (unless the machine is in the devs xml file)</param>
        /// <param name="ErrorEmailSubject">Subject of the error message.</param>
        /// <param name="SMTPServer">SMTP Server to use</param>
        /// <param name="ErrorPageURL">Optional - error page path (defaults to /error.aspx)</param>
        /// <param name="Error404PageURL">Optional - error page path for 404 errors (defaults to /error.aspx)</param>
        public String HandleErrorMVC(List<AdditionalInformation> AdditionalInfo, string ErrorRefCode = "")
        {
            Exception exception = Server.GetLastError();

            if (exception == null || HandleHttpError(exception, string.Empty, false) || HandleViewStateError(exception)) return ErrorRefCode;

            IErrorEmailSettings settings = new ErrorEmailSettings();
            // create the email
            var mailMsg = new MailMessage()
            {
                From = new MailAddress(settings.FromAddress),
                Subject = settings.Subject,
                Body = GenerateErrorEmail(exception, AdditionalInfo, ErrorRefCode)
            };
            // add the to addresses
            foreach (string email in GetErrorEmailAddresses(settings.DevUsersXmlPath, Environment.MachineName.ToUpper(), settings.ToAddresses.ToArray()))
            {
                mailMsg.To.Add(email);
            }
            // send the email
            new SmtpClient(settings.SmtpServer).Send(mailMsg);

            return ErrorRefCode;
        }

        /// <summary>
        /// Redirects 403/404 errors without sending emails
        /// </summary>
        private bool HandleHttpError(Exception exception, string errorPageUrl, bool redirect)
        {
            HttpException httpException = exception as HttpException;
            if (httpException != null)
            {
                switch (httpException.GetHttpCode())
                {
                    case 403:
                    case 404:
                        if(redirect) Response.Redirect(errorPageUrl, true);
                        return true;
                }
            }
            return false;
        }

        /// <summary>
        /// Redirects viewstate errors without sending emails
        /// </summary>
        private bool HandleViewStateError(Exception exception)
        {
            while (exception != null)
            {
                if (exception is System.Web.UI.ViewStateException)
                {
                    //Response.Redirect(errorPageUrl);
                    return true;
                }
                exception = exception.InnerException;
            }
            return false;
        }

        #endregion

        #region GenerateErrorEmail

        /// <summary>
        /// Sends an informative formatted error email based on information passed in.
        /// </summary>
        /// <param name="LastError">The exception</param>
        /// <param name="AdditionalInformationList">list of additional information to be displayed in the email.</param>
        private string GenerateErrorEmail(Exception LastError, List<AdditionalInformation> AdditionalInfo, string ErrorRefCode)
        {
            //display basic information about the exception.
            var errMsg = new StringBuilder();
            errMsg.AppendLine("Error in " + Request.RawUrl);
            errMsg.AppendLine();
            errMsg.AppendLine("Application Path: " + Server.MapPath("/"));
            errMsg.AppendLine();
            errMsg.AppendLine("User IP Address: " + Request.UserHostAddress);
            errMsg.AppendLine();
            errMsg.AppendLine("Browser: " + Request.Browser.Browser + " " + Request.Browser.Version);
            errMsg.AppendLine();
            errMsg.AppendLine("Timestamp: " + DateTime.Now.ToString());

            errMsg.AppendLine();
            errMsg.AppendLine("----------------------------------------------------------");

            // Append Exception
            errMsg.AppendLine();
            errMsg.AppendLine("EXCEPTION");
            errMsg.AppendLine(LastError.Message);
            if (!String.IsNullOrEmpty(LastError.StackTrace))
            {
                errMsg.AppendLine();
                errMsg.AppendLine("STACK TRACE");
                errMsg.AppendLine(LastError.StackTrace);
            }

            // Append Inner Exceptions
            for (var padding = "--"; LastError.InnerException != null; padding += "--", LastError = LastError.InnerException)
            {
                errMsg.AppendLine();
                errMsg.AppendLine();
                errMsg.Append(padding);
                errMsg.AppendLine(" INNER EXCEPTION");
                errMsg.AppendLine(LastError.InnerException.Message);
                if (!String.IsNullOrEmpty(LastError.InnerException.StackTrace))
                {
                    errMsg.AppendLine();
                    errMsg.Append(padding);
                    errMsg.AppendLine(" STACK TRACE");
                    errMsg.AppendLine(LastError.InnerException.StackTrace);
                }
            }

            //Add the additional information if there is any.
            if (AdditionalInfo != null && AdditionalInfo.Count > 0)
            {
                errMsg.AppendLine();
                errMsg.AppendLine("----------------------------------------------------------");
                errMsg.AppendLine();
                errMsg.AppendLine(" ADDITIONAL INFORMATION:");
                foreach (AdditionalInformation ai in AdditionalInfo)
                {
                    errMsg.AppendLine();
                    errMsg.AppendLine(" - " + ai.FieldName + ": " + ai.FieldValue);
                }
            }

            //Add the error reference code if there is any.
            if (ErrorRefCode != null && ErrorRefCode.Length > 0)
            {
                errMsg.AppendLine();
                errMsg.AppendLine("----------------------------------------------------------");
                errMsg.AppendLine();
                errMsg.AppendLine(" ERROR REFERENCE CODE:");
                errMsg.AppendLine();
                errMsg.AppendLine(" - " + ErrorRefCode);
            }

            //have a nice day.
            errMsg.AppendLine();
            errMsg.AppendLine("----------------------------------------------------------");
            errMsg.AppendLine();
            errMsg.AppendLine(" HAVE A NICE DAY :-)");

            return errMsg.ToString();
        }

        #endregion
        
        #region GetErrorEmailAddress

        private static string[] GetErrorEmailAddresses(string XMLFilePath, string MachineName, string[] DefaultEmailAddress)
        {
            if (System.IO.File.Exists(XMLFilePath))
            {
                //Load the xml file passed in by the user.
                System.Xml.Linq.XDocument xDoc = System.Xml.Linq.XDocument.Load(XMLFilePath);

                //Use linq to query the xml for the email address of the user based on Machine name.
                var userEmail = (from u in xDoc.Descendants("User")
                                 where (string)u.Attribute("MachineName") == MachineName
                                 select (string)u.Attribute("Email")).FirstOrDefault();

                //If no email address was found, return an empty string.
                if (userEmail == null)
                    return DefaultEmailAddress;
                else
                    return new string[] { userEmail };
            }
            else
            {
                return DefaultEmailAddress;
            }



        }

        #endregion

    }
}
