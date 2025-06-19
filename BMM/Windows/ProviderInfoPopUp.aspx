<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="ProviderInfoPopUp.aspx.cs" Inherits="BMM.Windows.ProviderInfoPopUp" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
    <title></title>
    <Telerik:RadCodeBlock runat="server" ID="rcbProviderInfo">
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
    <link href="../CSS/Modals.css" rel="stylesheet" type="text/css" />
</head>
<body>
    <form id="form1" runat="server">
    <asp:ScriptManager ID="scriptman1" runat="server" />
    <div class="Header">
            <div class="Title">Provider Information</div>
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
                <span class="modalLabels">Facility Abbreviation:&nbsp;&nbsp;</span><span class="modalText"><asp:Literal runat="server" ID="litFacility"></asp:Literal></span><br /><br />
                <span class="modalLabels">Discount Percentage:&nbsp;&nbsp;</span><span class="modalText"><asp:Literal runat="server" ID="litDiscount"></asp:Literal></span><br /><br />
                <span class="modalLabels">MRI Cost:&nbsp;&nbsp;</span><span class="modalText"><asp:Literal runat="server" ID="litMRI"></asp:Literal></span><br /><br />
                <span class="modalLabels">Days Until Payment Due:&nbsp;&nbsp;</span><span class="modalText"><asp:Literal runat="server" ID="litPaymentDue"></asp:Literal></span><br /><br />
            </div>
        </div>
        <div>            
            <span class="modalLabels">Notes:&nbsp;&nbsp;</span><span class="modalText"><asp:Literal runat="server" ID="litNotes"></asp:Literal></span><br /><br /><br />
            <span class="modalLabels">Contacts:</span><br /><br />
            <div style="text-align: center; padding-bottom: 20px;">
                <Telerik:RadAjaxPanel runat="server" ID="pnlProviderInfo">
                    <Telerik:RadGrid ID="grdProviderInfo" runat="server" PageSize="5" AllowPaging="true" EnableEmbeddedSkins="false" Skin="BMM" AutoGenerateColumns="false" Width="600px" OnNeedDataSource="grdProviderInfo_OnNeedDataSource">
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