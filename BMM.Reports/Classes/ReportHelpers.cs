using System;
using Telerik.Reporting.Expressions;

namespace BMM_Reports.Classes
{
    public static class ReportHelpers
    {
        #region + Enums

        enum DatePartEnum
        {
            DAY,
            MONTH,
            YEAR
        }

        #endregion

        #region + Public Methods

        /// <summary>
        /// Gets the last day of the month for a given datetime.
        /// </summary>
        /// <param name="dateTime"></param>
        /// <returns></returns>
        [Function(Category = "Date and Time", Description = "Gets the last day of the month for a given datetime.",
            Namespace = "ReportHelpers")]
        public static DateTime GetLastDayOfMonth(DateTime dateTime)
        {
            int year = dateTime.Year;
            int month = dateTime.Month;
            int day = DateTime.DaysInMonth(year, month);

            return new DateTime(year, month, day);
        }

        /// <summary>
        /// Returns a specified date with the specified number interval (signed integer) added to a specified datePart of that date.
        /// </summary>
        /// <param name="datePart"></param>
        /// <param name="number"></param>
        /// <param name="date"></param>
        /// <returns></returns>
        [Function(Category = "Date and Time",
            Description =
                "Returns a specified date with the specified number interval (signed integer) added to a specified datePart of that date.",
            Namespace = "ReportHelpers")]
        public static DateTime DateAdd(string datePart, int number, DateTime date)
        {
            switch (GetDatePart(datePart))
            {
                case DatePartEnum.DAY:
                    return DateAdd_Day(number, date);
                case DatePartEnum.MONTH:
                    return DateAdd_Month(number, date);
                case DatePartEnum.YEAR:
                    return DateAdd_Year(number, date);
            }

            return new DateTime();
        }

        #region + Divide Methods

        /// <summary>
        /// Divides two decimals and returns the result.
        /// </summary>
        /// <param name="numerator"></param>
        /// <param name="denominator"></param>
        /// <returns></returns>
        [Function(Category = "Math", Description = "Divides two decimals and returns the result.",
            Namespace = "ReportHelpers")]
        public static decimal Divide_Decimal(object numerator, object denominator)
        {
            var denominatorConverted = Convert.ToDecimal(denominator);
            var numeratorConverted = Convert.ToDecimal(numerator);

            return Divide_DecimalFunction(numeratorConverted, denominatorConverted);
        }

        /// <summary>
        /// Divides two decimals and returns the result or the defaultValue in the case of divide by 0.
        /// </summary>
        /// <param name="numerator"></param>
        /// <param name="denominator"></param>
        /// <param name="defaultValue"></param>
        /// <returns></returns>
        [Function(Category = "Math",
            Description = "Divides two decimals and returns the result or the defaultValue in the case of divide by 0.",
            Namespace = "ReportHelpers")]
        public static decimal Divide_Decimal(object numerator, object denominator, object defaultValue)
        {
            var denominatorConverted = Convert.ToDecimal(denominator);
            var numeratorConverted = Convert.ToDecimal(numerator);
            var defaultValueConverted = Convert.ToDecimal(defaultValue);

            return denominatorConverted == 0
                ? defaultValueConverted
                : Divide_DecimalFunction(numeratorConverted, denominatorConverted);
        }

        #endregion

        #endregion

        #region + Helper Methods

        /// <summary>
        /// Translates string to the proper DatePart.
        /// </summary>
        /// <param name="datePart"></param>
        /// <returns></returns>
        private static DatePartEnum GetDatePart(string datePart)
        {
            string datePartLowerCase = datePart.ToLower();

            if (datePartLowerCase == "day" || datePartLowerCase == "dd" || datePartLowerCase == "d")
            {
                return DatePartEnum.DAY;
            }

            if (datePartLowerCase == "month" || datePartLowerCase == "mm" || datePartLowerCase == "m")
            {
                return DatePartEnum.MONTH;
            }

            if (datePartLowerCase == "year" || datePartLowerCase == "yy" || datePartLowerCase == "yyyy")
            {
                return DatePartEnum.YEAR;
            }

            throw new Exception("Invalid DatePart: " + datePart);
        }

        /// <summary>
        /// Returns date with the number of days added.
        /// </summary>
        /// <param name="number"></param>
        /// <param name="date"></param>
        /// <returns></returns>
        private static DateTime DateAdd_Day(int number, DateTime date)
        {
            return date.AddDays(number);
        }

        /// <summary>
        /// Returns date with the number of months added.
        /// </summary>
        /// <param name="number"></param>
        /// <param name="date"></param>
        /// <returns></returns>
        private static DateTime DateAdd_Month(int number, DateTime date)
        {
            return date.AddMonths(number);
        }

        /// <summary>
        /// Returns date with the number of years added.
        /// </summary>
        /// <param name="number"></param>
        /// <param name="date"></param>
        /// <returns></returns>
        private static DateTime DateAdd_Year(int number, DateTime date)
        {
            return date.AddYears(number);
        }

        /// <summary>
        /// Divides two decimals and returns the result.
        /// </summary>
        /// <param name="numerator"></param>
        /// <param name="denominator"></param>
        /// <returns></returns>
        private static decimal Divide_DecimalFunction(decimal numerator, decimal denominator)
        {
            return numerator / denominator;
        }

        #endregion
    }
}
