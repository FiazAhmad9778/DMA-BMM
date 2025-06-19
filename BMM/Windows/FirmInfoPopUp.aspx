<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="FirmInfoPopUp.aspx.cs" Inherits="BMM.Windows.FirmInfoPopUp" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
    <title></title>
    <Telerik:RadCodeBlock runat="server" ID="rcbAttorneyInfo">
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
        </script>
    </Telerik:RadCodeBlock>
    <style>
        body
        {
            height: auto !important;
        }
        .Content 
        {
            width: 600px
        }
    </style>
    <link href="../CSS/Modals.css" rel="stylesheet" type="text/css" />
</head>
<body>
    <form id="form1" runat="server">
    <asp:ScriptManager ID="scriptman1" runat="server" />
    <div class="Header">
            <div class="Title">Firm Information</div>
            <asp:Image class="CloseButton" ID="imgCloseButton" onclick="Close()" runat="server" SkinID="imgCloseButton" AlternateText="X" />
    </div>
    <div class="Content">
        <div>

        </div>

        <div style="overflow: auto">
            <div style="float:left; width: 380px;">
                <span class="modalLabels"><asp:Literal runat="server" ID="litName" /></span><br />
                <br />
                <span class="modalLabels">Address:&nbsp;&nbsp;</span><span class="modalText"><asp:Literal ID="litAddress" runat="server" /></span><br />
                <br />
                <span class="modalLabels">Phone:&nbsp;&nbsp;</span><span class="modalText"><asp:Literal ID="litPhone" runat="server" /></span><br />
                <br />
                <span class="modalLabels">Fax:&nbsp;&nbsp;</span><span class="modalText"><asp:Literal ID="litFax" runat="server" /></span><br />
                <br />
            </div>
            <div style="float:left; width: 200px; margin-left: 20px">
                <span class="modalLabels">Attorneys in Firm:</span><br />
                <Telerik:RadGrid ID="grdAttorneys" runat="server" AllowPaging="true" PageSize="10" Width="200px" OnNeedDataSource="grdAttorneys_NeedDataSource" >
                    <MasterTableView>
                        <Columns>
                            <Telerik:GridTemplateColumn HeaderText="Attorneys" HeaderStyle-HorizontalAlign="Center">
                                <ItemStyle HorizontalAlign="Center" />
                                <ItemTemplate><%# Eval("FirstName").ToString() + " " + Eval("LastName").ToString() %></ItemTemplate>
                            </Telerik:GridTemplateColumn>
                        </Columns>
                    </MasterTableView>
                </Telerik:RadGrid>
                <br />
            </div>
        </div>

        <Telerik:RadAjaxPanel runat="server" ID="pnlContacts">
            <Telerik:RadGrid ID="grdContacts" runat="server" PageSize="5" AllowPaging="true" EnableEmbeddedSkins="false" Skin="BMM" AutoGenerateColumns="false" Width="600px" OnNeedDataSource="grdContacts_OnNeedDataSource">
                <MasterTableView>
                    <Columns>
                        <Telerik:GridTemplateColumn HeaderText="Name">
                            <ItemTemplate><%# Eval("Name") %></ItemTemplate>
                        </Telerik:GridTemplateColumn>
                        <Telerik:GridTemplateColumn HeaderText="Position">
                            <ItemTemplate><%# Eval("Position") %></ItemTemplate>
                        </Telerik:GridTemplateColumn>
                        <Telerik:GridTemplateColumn HeaderText="Phone">
                            <ItemTemplate><%# Eval("Phone") %></ItemTemplate>
                        </Telerik:GridTemplateColumn>
                        <Telerik:GridTemplateColumn HeaderText="Email Address">
                            <ItemTemplate><%# Eval("Email") %></ItemTemplate>
                        </Telerik:GridTemplateColumn>
                    </Columns>
                </MasterTableView>
            </Telerik:RadGrid>
        </Telerik:RadAjaxPanel>
    </div>
    </form>
    <script type="text/javascript">
        var wnd = GetRadWindow();
        wnd.autoSize();
        wnd.set_width(640);
        wnd.center();
    </script>
</body>
</html>