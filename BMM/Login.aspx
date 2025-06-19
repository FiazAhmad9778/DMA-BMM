<%@ Page Title="" Language="C#" MasterPageFile="~/Master.Master" AutoEventWireup="true" CodeBehind="Login.aspx.cs" Inherits="BMM.Login" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <asp:Panel runat="server" DefaultButton="btnLogin">
        <table class="Form" cellpadding="0" cellspacing="0" style="margin: 0 auto; padding-top: 20px;">
            <tbody>
                <tr>
                    <th><label for="<%= txtUsername.ClientID %>">Email Address:</label></th>
                    <td><asp:TextBox ID="txtUsername" runat="server" MaxLength="100" /></td>
                    <td><asp:RequiredFieldValidator ID="rfvUsername" runat="server" ControlToValidate="txtUsername" Display="Dynamic" CssClass="ErrorText" ErrorMessage="Required" /></td>
                </tr>
                <tr>
                    <th><label for="<%= txtPassword.ClientID %>">Password:</label></th>
                    <td><asp:TextBox id="txtPassword" runat="server" MaxLength="500" TextMode="Password" /></td>
                    <td><asp:RequiredFieldValidator ID="RequiredFieldValidator1" runat="server" ControlToValidate="txtPassword" Display="Dynamic" CssClass="ErrorText" ErrorMessage="Required" /></td>
                </tr>
                <tr>
                    <th></th>
                    <td class="Buttons" style="text-align: center;"><asp:Button ID="btnLogin" runat="server" Text="Login" CausesValidation="true" OnClick="btnLogin_Click" /></td>                    
                </tr>
                <tr>
                    <th></th>                    
                    <td style="text-align: center;"><a href="ForgotPassword.aspx">Forgot Your Password?</a></td>
                </tr>
            </tbody>
        </table>
        
        <div class="ErrorText">
            <asp:Literal ID="litPasswordError" runat="server" Visible="false" Text="Email Address and Password provided do not match. Please try again."></asp:Literal>
        </div>
    </asp:Panel>
</asp:Content>
