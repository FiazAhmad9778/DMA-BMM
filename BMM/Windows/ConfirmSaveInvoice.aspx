<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="ConfirmSaveInvoice.aspx.cs" Inherits="BMM.Windows.ConfirmSaveInvoice" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
    <script type="text/javascript">
        function Close(args) {
            var window = GetRadWindow();
            if (window != null) { window.Close(args); }
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
     <telerik:RadFormDecorator ID="RadFormDecorator3" runat="server" EnableEmbeddedSkins="false" DecoratedControls="Buttons" />        
        <div class="Header">
            <div class="Title">Save Invoice</div>
            <asp:Image class="CloseButton" ID="imgCloseButton" onclick="Close()" runat="server" SkinID="imgCloseButton" AlternateText="Test Image" />
        </div>
        <div class="Content">
            <table>
                <tr>
                    <td style="text-align: left; padding-bottom: 30px; padding-left:20px;">
                        <asp:Literal runat="server" id="litMessage">Do you want to save this Invoice?</asp:Literal>
                    </td>
                </tr>
                <tr>
                    <td style="text-align: center;">
                        <div class="Modal_Buttons" style="margin-left:15px">
                            <asp:Button ID="btnCancel" runat="server" OnClientClick="Close()" Text="No" />
                            <asp:Button ID="btnSubmit" runat="server" OnClick="btnSubmit_Click" Text="Yes" />
                        </div>                        
                    </td>
                </tr>
            </table>     
        </div>
    </form>
</body>
</html>
