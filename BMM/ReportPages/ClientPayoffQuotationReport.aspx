<%@ Page Language="C#" MasterPageFile="../Master.Master" AutoEventWireup="true" CodeBehind="ClientPayoffQuotationReport.aspx.cs" Inherits="BMM.ReportPages.ClientPayoffQuotationReport" %>



<%@ Register Assembly="Telerik.ReportViewer.WebForms, Version=17.2.23.1114, Culture=neutral, PublicKeyToken=a9d7983dfcc261be" Namespace="Telerik.ReportViewer.WebForms" TagPrefix="telerik" %>

<asp:Content runat="server" ID="content1" ContentPlaceHolderID="head">
    <script type="text/javascript">
        function OnClientKeyPressing(sender, args) {
            if (args.get_domEvent().keyCode == 13 && sender.get_value() != '') {
                $get("<%= btnGenerate.ClientID %>").click();
            }
        }
    </script>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">    
    <h1>Client Payoff Quotation</h1>

    <asp:Panel ID="pnlSearch" runat="server" DefaultButton="btnGenerate">
        <table class="Form" cellpadding="0" cellspacing="0">
            <colgroup>
               <col style="width: 5%;" />
               <col style="width: 10%;" />
               <col style="width: 5%;" />
               <col style="width: 5%;" />
               <col style="width: 10%;" />
            </colgroup>

            <tbody>
                <tr>
                    <th><label for="<%= rcbName.ClientID %>">Name:</label></th>
                    <td><telerik:RadComboBox ID="rcbName" runat="server" AllowCustomText="true" Filter="Contains" MinFilterLength="3" MarkFirstMatch="true" EnableLoadOnDemand="true" EnableItemCaching="true" OnItemsRequested="rcbName_ItemsRequested" OnClientKeyPressing="OnClientKeyPressing" /></td>  
                    <td><asp:RequiredFieldValidator ID="rfvName" runat="server" ControlToValidate="rcbName" Enabled="true" ErrorMessage="* Required" CssClass="ErrorText" Display="Dynamic" /></td>

                    <th><label for="<%= txtTo.ClientID %>">TO:</label></th>
                    <td><asp:TextBox ID="txtTo" runat="server" /></td>
                    <td><asp:RequiredFieldValidator ID="rfvTo" runat="server" ControlToValidate="txtTo" Enabled="true" ErrorMessage="* Required" CssClass="ErrorText" Display="Dynamic" /></td>
                </tr>

                <tr>
                    <th><label for="<%= rdpPayoffDate.ClientID %>">Payoff Date:</label></th>
                    <td><Telerik:RadDatePicker runat="server" ID="rdpPayoffDate" Width="125px"></Telerik:RadDatePicker></td>
                    <td></td><%--<td><asp:RequiredFieldValidator ID="rfvPayoffDate" runat="server" ControlToValidate="rdpPayoffDate" Enabled="true" ErrorMessage="* Required" CssClass="ErrorText" Display="Dynamic" /></td>--%>                   

                    <th><label for="<%= txtAttention.ClientID %>">ATTN:</label></th>
                    <td><asp:TextBox ID="txtAttention" runat="server" /></td>
                    <td><asp:RequiredFieldValidator ID="rfvAttention" runat="server" ControlToValidate="txtAttention" Enabled="true" ErrorMessage="* Required" CssClass="ErrorText" Display="Dynamic" /></td>
                </tr>

                <tr>
                    <th><label for="<%= rdpDateOfAccident.ClientID %>">Date of Accident:</label></th>
                    <td><Telerik:RadDatePicker runat="server" ID="rdpDateOfAccident" Width="125px"></Telerik:RadDatePicker></td>
                    <td></td><%--<td><asp:RequiredFieldValidator ID="rfvDateOfAccident" runat="server" ControlToValidate="rdpDateOfAccident" Enabled="true" ErrorMessage="* Required" CssClass="ErrorText" Display="Dynamic" /></td>--%>                  

                    <th><label for="<%= txtEmail.ClientID %>">EMAIL:</label></th>
                    <td><asp:TextBox ID="txtEmail" runat="server" /></td>
                    <td><asp:RequiredFieldValidator ID="rfvEmail" runat="server" ControlToValidate="txtEmail" Enabled="true" ErrorMessage="* Required" CssClass="ErrorText" Display="Dynamic" /></td>
                </tr>

                <tr>  
                    <th><label for="<%= cbIncomplete.ClientID %>">Incomplete:</label></th>
                    <td><asp:CheckBox ID="cbIncomplete" runat="server" /></td>
                    <td></td>

                    <th><label for="<%= rcbFrom.ClientID %>">FROM:</label></th>
                    <td><Telerik:RadComboBox ID="rcbFrom" runat="server" /></td>
                </tr>

                <tr>
                    <th></th><td></td><td></td>
                    <th><label for="<%= rcbFrom.ClientID %>">RE:</label></th>
                    <td><asp:TextBox ID="txtRegarding" runat="server" Text="Account Balance" /></td>
                    <td><asp:RequiredFieldValidator ID="rfvRegarding" runat="server" ControlToValidate="txtRegarding" Enabled="true" ErrorMessage="* Required" CssClass="ErrorText" Display="Dynamic" /></td>
                </tr>
            </tbody>
        </table>

        <asp:Button ID="btnGenerate" runat="server" Text="Generate" CausesValidation="true" OnClick="btnGenerate_OnClick" />

        <p class="ErrorText"><asp:Literal ID="litError" runat="server" /></p>
    </asp:Panel>        

    <div style="clear: both;" />
    <br />

    <telerik:ReportViewer runat="server" ID="rptClientPayoffQuotation" Width="100%" Height="1115px" ViewMode="PrintPreview" ParametersAreaVisible="False" ShowParametersButton="False" ShowPrintPreviewButton="False" ></telerik:ReportViewer>
</asp:Content>