<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="ConfirmDeleteICDCode.aspx.cs" Inherits="BMM.Windows.ConfirmDeleteICDCode" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
    <title></title>
        <script type="text/javascript">
            function Close(deleted, id) {
                // Close Window
                var window = GetRadWindow();
                if (window != null) {
                    window.Close({ 'deleted': deleted, 'id': id });
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
            <div class="Title">Confirm ICD Code Deletion</div>
            <asp:Image class="CloseButton" ID="imgCloseButton" onclick="Close(false)" runat="server" SkinID="imgCloseButton" AlternateText="Test Image" />
        </div>
        <div class="Content">
            <table>
                <tr>
                    <td style="text-align: left; padding-bottom: 30px;">
                        <asp:Literal runat="server" id="litMessage"></asp:Literal>
                    </td>
                </tr>
                <tr>
                    <td style="text-align: center;">
                        <div class="Modal_Buttons">
                            <asp:Button ID="btnCancel" runat="server" OnClientClick="Close(false)" Text="No" />
                            <asp:Button ID="btnSubmit" runat="server" OnClick="btnSubmit_Click" Text="Yes" />
                        </div>
                    </td>
                </tr>
            </table>     
        </div>
    </form>
</body>
</html>
