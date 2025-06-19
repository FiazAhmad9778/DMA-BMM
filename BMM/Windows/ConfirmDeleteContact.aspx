<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="ConfirmDeleteContact.aspx.cs" Inherits="BMM.Windows.ConfirmDeleteContact" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
    <script type="text/javascript">
        function CloseNo() {

            var window = GetRadWindow();
            if (window != null) {
                window.Close(false);
            }
        }
        function CloseYes() {
            // Close Window
            var window = GetRadWindow();
            if (window != null) {
                window.Close(true);
            }
        }
        function GetRadWindow() {
            var oWindow = null;
            if (window.radWindow) oWindow = window.radWindow; //Will work in Moz in all cases, including clasic dialog
            else if (window.frameElement.radWindow) oWindow = window.frameElement.radWindow; //IE (and Moz az well)
            return oWindow;
        }
    </script>
    <link href="../CSS/Modals.css" rel="stylesheet" type="text/css" />
</head>
<body>
    <form id="form1" runat="server">
        <asp:ScriptManager ID="scriptman1" runat="server" />
        <telerik:RadFormDecorator ID="RadFormDecorator2" runat="server" EnableEmbeddedSkins="false" DecoratedControls="Buttons" />
        <div class="Header">
            <div class="Title">Confirm Contact Deletion</div>
            <asp:Image class="CloseButton" ID="imgCloseButton" onclick="CloseNo()" runat="server" SkinID="imgCloseButton" AlternateText="Test Image" />
        </div>
        <div class="Content">
            Are you sure you want to delete this contact?
            <div class="Modal_Buttons">
                <asp:Button ID="btnCancel" runat="server" OnClientClick="CloseNo()" Text="No" />
                <asp:Button ID="btnSubmit" runat="server" OnClientClick="CloseYes()" Text="Yes" />
            </div>
        </div>
    </form>
</body>
</html>
