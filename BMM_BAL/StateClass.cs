using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using BMM_DAL;
using System.Data.Linq;

namespace BMM_BAL
{
    public class StateClass
    {
        #region GetStates
        /// <summary>
        /// Gets a list of active states
        /// </summary>
        /// <returns></returns>
        public static List<State> GetStates()
        {
            List<State> retList;

            using (DataModelDataContext db = new DataModelDataContext())
            {
                retList = (from s in db.States
                          where s.Active == true
                          select s).ToList();
            }

            return retList;
        }
        #endregion
    }
}
