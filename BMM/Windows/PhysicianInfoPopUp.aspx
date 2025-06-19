<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="PhysicianInfoPopUp.aspx.cs" Inherits="BMM.Windows.PhysicianInfoPopUp" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
    <title></title>
    <link href="../CSS/Modals.css" rel="stylesheet" type="text/css" />
    <script type="text/javascript" src="https://ajax.googleapis.com/ajax/libs/jquery/1.7.1/jquery.min.js"></script>
    <Telerik:RadCodeBlock runat="server" ID="rcbPhysicianInfo">
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
            <div class="Title">Physician Information</div>
            <asp:Image class="CloseButton" ID="imgCloseButton" onclick="Close()" runat="server" SkinID="imgCloseButton" AlternateText="Test Image" />
    </div>
    <div class="Content">
        <div class="information">
            <span class="modalLabels"><asp:Literal runat="server" ID="litName"></asp:Literal></span><br /><br />
            <span class="modalLabels">Address:&nbsp;&nbsp;</span><span class="modalText">
                <asp:Literal runat="server" ID="litAddress"></asp:Literal>
            </span><br /><br />
            <span class="modalLabels">Phone:&nbsp;&nbsp;</span><span class="modalText"><asp:Literal runat="server" ID="litPhone"></asp:Literal></span><br /><br />
            <span class="modalLabels">Fax:&nbsp;&nbsp;</span><span class="modalText"><asp:Literal runat="server" ID="litFax"></asp:Literal></span><br /><br />
            <span class="modalLabels">Email Address:&nbsp;&nbsp;</span><span class="modalText"><asp:Literal runat="server" ID="litEmail"></asp:Literal></span><br /><br />
            <span class="modalLabels">Notes:&nbsp;&nbsp;</span><span class="modalText"><asp:Literal runat="server" ID="litNotes"></asp:Literal></span><br /><br /><br />
        </div>
        <div>            
            <span class="modalLabels">Contacts:</span><br /><br />
            <div style="text-align: center; padding-bottom: 20px;">
                <Telerik:RadAjaxPanel runat="server" ID="pnlPhysicianInfo">
                    <Telerik:RadGrid ID="grdPhysicianInfo" runat="server" PageSize="5" AllowPaging="true" EnableEmbeddedSkins="false" Skin="BMM" AutoGenerateColumns="false" Width="600px" OnNeedDataSource="grdPhysicianInfo_OnNeedDataSource">
                        <MasterTableView>
                            <Columns>
                                <Telerik:GridTemplateColumn HeaderText="Name" ItemStyle-HorizontalAlign="Left">
                                    <ItemTemplate>
                                        <%# Eval("Name")%>
                                    </ItemTemplate>
                                </Telerik:GridTemplateColumn>
                                <Telerik:GridTemplateColumn HeaderText="Position" ItemStyle-HorizontalAlign="Left">
                                    <ItemTemplate>
                                        <%# Eval("Position")%>
                                    </ItemTemplate>
                                </Telerik:GridTemplateColumn>
                                <Telerik:GridTemplateColumn HeaderText="Phone" ItemStyle-HorizontalAlign="Left">
                                    <ItemTemplate>
                                        <%# Eval("Phone")%>
                                    </ItemTemplate>
                                </Telerik:GridTemplateColumn>
                                <Telerik:GridTemplateColumn HeaderText="Email Address" ItemStyle-HorizontalAlign="Left">
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