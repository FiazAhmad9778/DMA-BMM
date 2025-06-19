using System.Collections.Generic;
using System.Configuration;
using System.Linq;

namespace InfiniedgeLibrary.ExceptionHandling.Classes
{
    public interface IErrorEmailSettings
    {
        string SmtpServer { get; }
        string Subject { get; }
        string FromAddress { get; }
        List<string> ToAddresses { get; }
        string DevUsersXmlPath { get; }
    }

    public class ErrorEmailSettings : IErrorEmailSettings
    {
        private static readonly ErrorEmailConfigurationSection Settings;

        static ErrorEmailSettings()
        {
            Settings = ConfigurationManager.GetSection("ErrorEmailSettings") as ErrorEmailConfigurationSection;
        }

        #region IErrorEmailSettings Members

        public string SmtpServer
        {
            get { return Settings.SmtpServer; }
        }

        public string Subject
        {
            get { return Settings.Subject; }
        }

        public string FromAddress
        {
            get { return Settings.FromAddress; }
        }

        public List<string> ToAddresses
        {
            get { return Settings.ToAddresses; }
        }

        public string DevUsersXmlPath
        {
            get { return Settings.DevUsersXmlPath; }
        }

        #endregion
    }

    public class ErrorEmailConfigurationSection : ConfigurationSection, IErrorEmailSettings
    {
        private static readonly ConfigurationPropertyCollection PropertyCollection;

        private static readonly ConfigurationProperty SmtpServerProperty;
        private static readonly ConfigurationProperty SubjectProperty;
        private static readonly ConfigurationProperty FromAddressProperty;
        private static readonly ConfigurationProperty ToAddressesProperty;
        private static readonly ConfigurationProperty DevUsersXmlPathProperty;

        static ErrorEmailConfigurationSection()
        {
            SmtpServerProperty = new ConfigurationProperty("SmtpServer", typeof(string), null, ConfigurationPropertyOptions.IsRequired);
            SubjectProperty = new ConfigurationProperty("Subject", typeof(string), null, ConfigurationPropertyOptions.IsRequired);
            FromAddressProperty = new ConfigurationProperty("FromAddress", typeof(string), null, ConfigurationPropertyOptions.IsRequired);
            ToAddressesProperty = new ConfigurationProperty("ToAddresses", typeof(CommaDelimitedStringCollection), null, new CommaDelimitedStringCollectionConverter(), null, ConfigurationPropertyOptions.IsRequired);
            DevUsersXmlPathProperty = new ConfigurationProperty("DevUsersXmlPath", typeof(string), null, ConfigurationPropertyOptions.IsRequired);
            PropertyCollection = new ConfigurationPropertyCollection { SmtpServerProperty, SubjectProperty, FromAddressProperty, ToAddressesProperty, DevUsersXmlPathProperty };
        }

        protected override ConfigurationPropertyCollection Properties
        {
            get { return PropertyCollection; }
        }

        #region IErrorEmailSettings Members

        public string SmtpServer
        {
            get { return (string)this[SmtpServerProperty]; }
        }

        public string Subject
        {
            get { return (string)this[SubjectProperty]; }
        }

        public string FromAddress
        {
            get { return (string)this[FromAddressProperty]; }
        }

        public List<string> ToAddresses
        {
            get
            {
                var collection = (CommaDelimitedStringCollection)this[ToAddressesProperty];
                var list = new List<string>(collection.Cast<string>());
                return list;
            }
        }

        public string DevUsersXmlPath
        {
            get { return (string)this[DevUsersXmlPathProperty]; }
        }

        #endregion
    }
}
