<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="AttorneyInfoPopUp.aspx.cs" Inherits="BMM.Windows.AttorneyInfoPopUp" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
    <title></title>
    <link href="../CSS/Modals.css" rel="stylesheet" type="text/css" />
    <script type="text/javascript" src="https://ajax.googleapis.com/ajax/libs/jquery/1.7.1/jquery.min.js"></script>
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
            $(function () {
                var wnd = GetRadWindow();
                wnd.autoSize();
                wnd.set_width(640);
                wnd.set_height($('form').height());
                wnd.center();
            });
        </script>
    </Telerik:RadCodeBlock>
</head>
<body>
    <form id="form1" runat="server">
    <asp:ScriptManager ID="scriptman1" runat="server" />
    <div class="Header">
            <div class="Title">Attorney Information</div>
            <asp:Image class="CloseButton" ID="imgCloseButton" onclick="Close()" runat="server" SkinID="imgCloseButton" AlternateText="Test Image" />
    </div>
    <div class="Content">
        <div class="information">
            <div class="infoLeft">
                <span class="modalLabels"><asp:Literal runat="server" ID="litName"></asp:Literal></span><br /><br />
                <span class="modalLabels">Address:&nbsp;&nbsp;</span><span class="modalText">
                    <asp:Literal runat="server" ID="litAddress"></asp:Literal>
                </span><br /><br />
                <span class="modalLabels">Phone:&nbsp;&nbsp;</span><span class="modalText"><asp:Literal runat="server" ID="litPhone"></asp:Literal></span><br /><br />
                <span class="modalLabels">Fax:&nbsp;&nbsp;</span><span class="modalText"><asp:Literal runat="server" ID="litFax"></asp:Literal></span><br /><br />
                <span class="modalLabels">Email Address:&nbsp;&nbsp;</span><span class="modalText"><asp:Literal runat="server" ID="litEmail"></asp:Literal></span><br /><br />
            </div>
            <div class="infoRight">
                <span class="modalLabels">Firm:&nbsp;&nbsp;</span><span class="modalText"><asp:Literal runat="server" ID="litFirm"></asp:Literal></span><br /><br />
                <span class="modalLabels">Discount Notes:&nbsp;&nbsp;</span><span class="modalText"><asp:Literal runat="server" ID="litDiscountNotes"></asp:Literal></span><br /><br />
                <span class="modalLabels">Deposit Amount Required:&nbsp;&nbsp;</span><span class="modalText"><asp:Literal runat="server" ID="litDepositAmount"></asp:Literal></span><br /><br />
                <span class="modalLabels">Status:&nbsp;&nbsp;</span><span class="modalText"><asp:Literal runat="server" ID="litStatus"></asp:Literal></span><br /><br />
            </div>
        </div>
        <div>
            <span class="modalLabels">Notes:&nbsp;&nbsp;</span><span class="modalText"><asp:Literal runat="server" ID="litNotes"></asp:Literal></span><br /><br /><br />
            <span class="modalLabels">Contacts:</span><br /><br />
            <div style="text-align: center; padding-bottom: 20px;">
                <Telerik:RadAjaxPanel runat="server" ID="pnlAttorneyInfo">
                    <Telerik:RadGrid ID="grdAttorneyInfo" runat="server" PageSize="5" AllowPaging="true" EnableEmbeddedSkins="false" Skin="BMM" AutoGenerateColumns="false" Width="600px" OnNeedDataSource="grdAttorneyInfo_OnNeedDataSource">
                        <MasterTableView>
                            <Columns>
                                <Telerik:GridTemplateColumn HeaderText="Name">
                                    <ItemTemplate>
                                        <%# Eval("Name")%>
                                    </ItemTemplate>
                                </Telerik:GridTemplateColumn>
                                <Telerik:GridTemplateColumn HeaderText="Position">
                                    <ItemTemplate>
                                        <%# Eval("Position")%>
                                    </ItemTemplate>
                                </Telerik:GridTemplateColumn>
                                <Telerik:GridTemplateColumn HeaderText="Phone">
                                    <ItemTemplate>
                                        <%# Eval("Phone")%>
                                    </ItemTemplate>
                                </Telerik:GridTemplateColumn>
                                <Telerik:GridTemplateColumn HeaderText="Email Address">
                                    <ItemTemplate>
                                        <%# Eval("Email")%>
                                    </ItemTemplate>
                                </Telerik:GridTemplateColumn>
                            </Columns>
                        </MasterTableView>
                    </Telerik:RadGrid>
                </Telerik:RadAjaxPanel>
            </div>
        </div>
    </div>
    </form>
</body>
</html>