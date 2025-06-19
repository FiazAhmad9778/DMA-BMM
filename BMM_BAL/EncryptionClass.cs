using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Data;
using System.Security.Cryptography;
using System.IO;

namespace BMM_BAL
{
    public class EncryptionClass
    {
        #region Decrypt

        public static string Decrypt(string encString)
        {
            string key = System.Configuration.ConfigurationSettings.AppSettings["Password"].ToString();
            string iv = System.Configuration.ConfigurationSettings.AppSettings["InitialVector"].ToString();

            if (String.IsNullOrEmpty(encString))
            {
                return "";
            }
            DESCryptoServiceProvider cryptoProvider = new DESCryptoServiceProvider();
            MemoryStream memoryStream = new MemoryStream
                    (Convert.FromBase64String(encString));
            CryptoStream cryptoStream = new CryptoStream(memoryStream, cryptoProvider.CreateDecryptor(ASCIIEncoding.ASCII.GetBytes(key), ASCIIEncoding.ASCII.GetBytes(iv)), CryptoStreamMode.Read);
            StreamReader reader = new StreamReader(cryptoStream);
            return reader.ReadToEnd();
        }

        #endregion

        #region Encrypt

        public static string Encrypt(string plainString)
        {
            string key = System.Configuration.ConfigurationSettings.AppSettings["Password"].ToString();
            string iv = System.Configuration.ConfigurationSettings.AppSettings["InitialVector"].ToString();

            if (String.IsNullOrEmpty(plainString))
            {
                return "";
            }
            DESCryptoServiceProvider cryptoProvider = new DESCryptoServiceProvider();
            MemoryStream memoryStream = new MemoryStream();
            CryptoStream cryptoStream = new CryptoStream(memoryStream,
                cryptoProvider.CreateEncryptor(ASCIIEncoding.ASCII.GetBytes(key), ASCIIEncoding.ASCII.GetBytes(iv)), CryptoStreamMode.Write);
            StreamWriter writer = new StreamWriter(cryptoStream);
            writer.Write(plainString);
            writer.Flush();
            cryptoStream.FlushFinalBlock();
            writer.Flush();
            return Convert.ToBase64String(memoryStream.GetBuffer(), 0, (int)memoryStream.Length);
        }

        #endregion

    }
}
