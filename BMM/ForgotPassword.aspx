<%@ Page Title="" Language="C#" MasterPageFile="~/Master.Master" AutoEventWireup="true" CodeBehind="ForgotPassword.aspx.cs" Inherits="BMM.ForgotPassword" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
<div id="ForgotPassword">
    <h1>Forgot Your Password?</h1>
    <p> Contact your system administrator to have your password updated to one of your choosing. Otherwise, you may submit your email address below to have a new password auto-generated and emailed to you.</p>
    <asp:Panel ID="panel1" runat="server" DefaultButton="btnSubmit">

    <table class="Form" cellpadding="0" cellspacing="0">
        <tbody>
            <tr>
                <th><label for="<%= txtUsername.ClientID %>">Email Address:</label></th>
                <td><asp:TextBox ID="txtUsername" runat="server" /></td>
                <td>
                    <asp:RequiredFieldValidator ID="rfvUsername" runat="server" ControlToValidate="txtUsername" Display="Dynamic" CssClass="ErrorText" ErrorMessage="Required" />
                    <asp:CustomValidator ID="cvValidUsername" runat="server" OnServerValidate="cvValidUsername_Validate" ControlToValidate="txtUsername" Display="Dynamic" CssClass="ErrorText" ErrorMessage="Invalid Email Address" />
                </td>
            </tr>
            <tr>
                <th></th>
                <td class="Buttons">
                    <asp:Button ID="btnCancel" runat="server" Text="Cancel" CausesValidation="false" OnClick="btnCancel_Click" />
                    <asp:Button ID="btnSubmit" runat="server" Text="Submit" CausesValidation="true" OnClick="btnSubmit_Click" />
                </td>
                <td></td>
            </tr>
        </tbody>
    </table>

    </asp:Panel>
</div>
</asp:Content>
