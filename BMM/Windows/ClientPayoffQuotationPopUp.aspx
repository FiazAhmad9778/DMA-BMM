<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="ClientPayoffQuotationPopUp.aspx.cs" Inherits="BMM.Windows.ClientPayoffQuotationPopUp" %>



<%@ Register Assembly="Telerik.ReportViewer.WebForms, Version=17.2.23.1114, Culture=neutral, PublicKeyToken=a9d7983dfcc261be" Namespace="Telerik.ReportViewer.WebForms" TagPrefix="telerik" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
    <head id="Head1" runat="server">
        <title></title>
        <link href="../CSS/Global.css" rel="stylesheet" type="text/css" />
        <link href="../CSS/Modals.css" rel="stylesheet" type="text/css" />
        <script type="text/javascript" src="https://ajax.googleapis.com/ajax/libs/jquery/1.7.1/jquery.min.js"></script>
        <Telerik:RadCodeBlock runat="server" ID="rcbClientPayoffQuotation">
            <script type="text/javascript">
                function Close(args) {
                    //Close Window
                    var window = GetRadWindow();
                    if (window != null) {
                       window.Close(args);
                    }
                }
                function GetRadWindow() {
                       var oWindow = null;
                       if (window.radWindow) oWindow = window.radWindow; //Will work in Moz in all cases, including clasic dialog
                       else if (window.frameElement.radWindow) oWindow = window.frameElement.radWindow; //IE (and Moz az well)
                       return oWindow;
                   }
                //$(function () {
                //    var wnd = GetRadWindow();
                //    wnd.autoSize();
                //    wnd.set_width(640);
                //    wnd.set_height($('form').height());
                //    wnd.center();
                //});

                function OnClientKeyPressing(sender, args) {
                    if (args.get_domEvent().keyCode == 13 && sender.get_value() != '') {
                        $get("<%= btnGenerate.ClientID %>").click();
                    }
                }
            </script>
        </Telerik:RadCodeBlock>
    </head>
    <body>
        <form id="form1" runat="server">
            <asp:ScriptManager ID="scriptman1" runat="server" />
            <div class="Header">
                    <div class="Title" style="font-size: 16px;">Client Payoff Quotation</div>
                    <asp:Image class="CloseButton" ID="imgCloseButton" onclick="Close()" runat="server" SkinID="imgCloseButton" AlternateText="Test Image" />
            </div>

            <asp:Panel ID="pnlSearch" runat="server" style="padding: 25px;" DefaultButton="btnGenerate">
                <table class="Form" cellpadding="0" cellspacing="0">
                    <colgroup>
                       <col style="width: 5%;" />
                       <col style="width: 10%;" />
                       <col style="width: 10%;" />
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
            </asp:Panel>        

            <div style="clear: both;" />
            <br />

            <telerik:ReportViewer runat="server" ID="rptClientPayoffQuotation" Width="100%" Height="1115px" ViewMode="PrintPreview" ParametersAreaVisible="False" ShowParametersButton="False" ShowPrintPreviewButton="False" ></telerik:ReportViewer>
        </form>
    </body>
</html>