using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using BMM_DAL;
using System.Data.Linq;

namespace BMM_BAL
{
    public class CompanyClass
    {
        #region GetCompanies

        public static List<Company> GetCompanies()
        {
            List<Company> retval;

            using (DataModelDataContext db = new DataModelDataContext())
            {
                retval = db.Companies.ToList();
            }

            return retval;
        }

        #endregion

        #region GetCompanyByID

        public static Company GetCompanyByID(Int32 ID)
        {
            Company retval;

            using (DataModelDataContext db = new DataModelDataContext())
            {
                retval = (from c in db.Companies
                          where c.ID == ID
                          select c).FirstOrDefault();
            }

            return retval;
        }

        #endregion
    }
}
