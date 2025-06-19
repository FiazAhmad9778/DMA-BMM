<%@ Page Title="" Language="C#" MasterPageFile="~/Master.Master" AutoEventWireup="true" CodeBehind="Home.aspx.cs" Inherits="BMM.Home" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
<link href="CSS/Home.css" rel="stylesheet" type="text/css" />
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <script type="text/javascript">
        function CheckStartEndDates(sender, args) {
            var startDatePicker = $find("<%= rdpStartDate.ClientID %>");
            var startDate = startDatePicker.get_selectedDate();

            var endDatePicker = $find("<%= rdpEndDate.ClientID %>");
            var endDate = endDatePicker.get_selectedDate();

            if (endDate != null && startDate != null) {
                if (endDate < startDate) {
                    args.IsValid = false;
                }
                else {
                    args.IsValid = true;
                }
            }
        
        }
    </script>

    <div class="homeScreen">
        <h1 style="text-align: center;">Quick Statistics</h1>
        <asp:RequiredFieldValidator ID="rfvStartDate" runat="server" ControlToValidate="rdpStartDate" Display="Dynamic" Text="* Start Date Required <br />" CssClass="ErrorText"></asp:RequiredFieldValidator>
        <asp:RequiredFieldValidator ID="rfvEndDate" runat="server" ControlToValidate="rdpEndDate" Display="Dynamic" Text="* End Date Required" CssClass="ErrorText"></asp:RequiredFieldValidator>
            <asp:CustomValidator ID="cvDateRange" runat="server" Display="Dynamic" ControlToValidate="" ClientValidationFunction="CheckStartEndDates" Text="* Start date must come before End date" CssClass="ErrorText"></asp:CustomValidator>
        <div id="Home_Dates">
            <div>
                <div>
                    Start Date:
                    <Telerik:RadDatePicker ID="rdpStartDate" Width="125px" runat="server"></Telerik:RadDatePicker>
                </div>
                <div>
                    End Date:
                    <Telerik:RadDatePicker ID="rdpEndDate" Width="125px" runat="server"></Telerik:RadDatePicker>
                </div>

                <asp:Button ID="Button1" OnClick="btnUpdateStatistiscs_Click" runat="server" Text="Update Statistics" />
            </div>
        </div>
        <div class="Report_DivHeader">
            <h2>General Statistics</h2>  
        </div>
        <div class="Report_DivContent">
            <table id="HomePageReport" cellpadding="0" cellspacing="0">
                <tbody>
                    <tr>
                        <td>
                            <div>
                                Total Tests for Selected Time Period:
                                <div><asp:Literal ID="litTotalTest" runat="server"></asp:Literal></div>
                            </div>
                        </td>
                        <td>
                            <div>
                                Total Amount Collected during Selected Time Period:
                                <div><asp:Literal ID="litTotalAmount" runat="server"></asp:Literal></div>
                            </div>
                        </td>
                        <td>
                            <div>
                                Last Test Invoice ID                        
                                <div><asp:Literal ID="litLastTestInvoiceID" runat="server"></asp:Literal></div>
                            </div>
                        </td>                  
                    </tr>
                    <tr>
                        <td>
                            <div>
                                Total Surgeries for Selected Time Period:
                                <div><asp:Literal ID="litTotalSurgeries" runat="server"></asp:Literal></div>
                            </div>
                        </td>
                        <td>
                            <div>
                                Payments Made to Providers during Selected Time Period:
                                <div><asp:Literal ID="litPaymentsMade" runat="server"></asp:Literal></div>
                            </div>
                        </td>
                            <td>
                            <div>
                                Last Surgery Invoice ID                         
                                <div><asp:Literal ID="litLastSurgeryInvoiceID" runat="server"></asp:Literal></div>
                            </div>
                        </td>
                    </tr>
                </tbody>
            </table>
        </div>
    </div>
</asp:Content>
