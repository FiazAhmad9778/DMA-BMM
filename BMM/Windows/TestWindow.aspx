<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="TestWindow.aspx.cs" Inherits="BMM.Windows.TestWindow" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
    <script type="text/javascript">
        function Close(args) {
            // Close Window
            //var window = GetRadWindow();
            //if (window != null) {
             //   window.Close(args);
            //}
        }
    </script>
    <link href="../CSS/Modals.css" rel="stylesheet" type="text/css" />
</head>
<body>
    <form id="form1" runat="server">
    <div class="Header">
            <div class="Title">Attorney Information</div>
            <img class="CloseButton" src="../Images/Modals/btn_close.png" alt="Close" onclick="Close()" />
    </div>
    <div class="Content">
        Some test content here.
    </div>
    </form>
</body>
</html>
