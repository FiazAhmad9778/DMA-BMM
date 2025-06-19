using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Configuration;
using BMM_DAL;

namespace BMM.Classes
{
    public class Utility
    {
        public static List<Invoice> Invoices;

        #region GenerateRandomPassword
        /// <summary>
        /// Generates a random password using a Guid
        /// </summary>
        /// <returns>returns the randomly generated password.</returns>
        public static string GenerateRandomPassword()
        {
            string characters = ConfigurationManager.AppSettings["RandomPasswordCharacters"];
            int length = int.Parse(ConfigurationManager.AppSettings["RandomPasswordLength"]);
            Random random = new Random();
            string password = String.Empty;
            for (int i = 0; i < length; i++)
            {
                password += characters[random.Next(characters.Length)];
            }
            return password;
        }
        #endregion

        public static string FormatSSN(string ssn)
        {
            if (String.IsNullOrEmpty(ssn) || ssn.Length != 9)
                return ssn;
            return ssn.Substring(0, 3) + "-" + ssn.Substring(3, 2) + "-" + ssn.Substring(5, 4);
        }
    }
}