<%@ Page Title="" Language="C#" MasterPageFile="~/Master.Master" AutoEventWireup="true" CodeBehind="AddEditPhysician.aspx.cs" Inherits="BMM.AddEditPhysician" %>

<%@ Register Src="Controls/UserControl_Contacts.ascx" TagName="Contacts" TagPrefix="uc" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <link href="CSS/ManageAddEdit.css" rel="stylesheet" type="text/css" />
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
<h1><asp:Literal ID="litHeader" runat="server"></asp:Literal></h1>
<asp:Panel ID="Panel1" runat="server" DefaultButton="btnSave">
<table class="Form FormPadding" cellpadding="0" cellspacing="0">
    <tbody>
        <tr>
            <th><label for="">* First Name:</label></th>
            <td><asp:TextBox ID="txtFirstName" runat="server" MaxLength="100"></asp:TextBox></td>
            <td><asp:RequiredFieldValidator id="rfvFirstName" runat="server" CssClass="ErrorText" ControlToValidate="txtFirstName" Display="Dynamic" ErrorMessage="Required"></asp:RequiredFieldValidator></td>
        </tr>
        <tr>
            <th><label for="">* Last Name:</label></th>
            <td><asp:TextBox ID="txtLastName" runat="server" MaxLength="100"></asp:TextBox></td>
            <td><asp:RequiredFieldValidator id="rfvLastName" runat="server" CssClass="ErrorText" ControlToValidate="txtLastName" Display="Dynamic" ErrorMessage="Required"></asp:RequiredFieldValidator></td>
        </tr>
        <tr>
            <th><h2>Address:</h2></th>
        </tr>
        <tr>
            <th><label for="">* Street:</label></th>
            <td><asp:TextBox ID="txtStreet1" runat="server" MaxLength="100"></asp:TextBox></td>
            <td><asp:RequiredFieldValidator id="rfvStreet1" runat="server" CssClass="ErrorText" ControlToValidate="txtStreet1" Display="Dynamic" ErrorMessage="Required"></asp:RequiredFieldValidator></td>
        </tr>
        <tr>
            <th><label for="">Apt or Suite:</label></th>
            <td><asp:TextBox ID="txtStreet2" runat="server" MaxLength="100"></asp:TextBox></td>
            <td></td>
        </tr>
        <tr>
            <th><label for="">* City:</label></th>
            <td><asp:TextBox ID="txtCity" runat="server" MaxLength="100"></asp:TextBox></td>
            <td><asp:RequiredFieldValidator id="rfvCity" runat="server" CssClass="ErrorText" ControlToValidate="txtCity" Display="Dynamic" ErrorMessage="Required"></asp:RequiredFieldValidator></td>
        </tr>
        <tr>
            <th><label for="">* State:</label></th>
            <td><Telerik:RadComboBox ID="rcbState" runat="server"></Telerik:RadComboBox></td>
            <td><asp:RequiredFieldValidator ID="rfvState" runat="server" CssClass="ErrorText" ControlToValidate="rcbState" Display="Dynamic" ErrorMessage="Required"></asp:RequiredFieldValidator></td>
        </tr>
        <tr>
            <th><label for="">* Zip Code:</label></th>
            <td><asp:TextBox ID="txtZip" runat="server"></asp:TextBox></td>
            <td colspan="2">
                <asp:RegularExpressionValidator ID="revZipCode" runat="server" ControlToValidate="txtZip" Display="Dynamic" CssClass="ErrorText" ErrorMessage="Invalid Zip Code" ValidationExpression="^\d{5}(-\d{4})?$"></asp:RegularExpressionValidator>
                <asp:RequiredFieldValidator ID="rfvZip" runat="server" CssClass="ErrorText" ControlToValidate="txtZip" Display="Dynamic" ErrorMessage="Requred"></asp:RequiredFieldValidator>
            </td>
        </tr>
        <tr>
            <th><label for="">* Phone:</label></th>
            <td><asp:TextBox ID="txtPhone" runat="server"></asp:TextBox></td>
            <td colspan="2">
                <asp:RequiredFieldValidator id="rfvPhone" runat="server" CssClass="ErrorText" ControlToValidate="txtPhone" Display="Dynamic" ErrorMessage="Required"></asp:RequiredFieldValidator>
            </td>
        </tr>
        <tr>
            <th><label for="">Fax:</label></th>
            <td><asp:TextBox ID="txtFax" runat="server"></asp:TextBox></td>
            <td colspan="2"></td>
        </tr>
        <tr>
            <th><label for="">Email Address:</label></th>
            <td><asp:TextBox ID="txtEmail" runat="server"></asp:TextBox></td>
            <td><asp:RegularExpressionValidator ID="RegularExpressionValidator1" runat="server" ControlToValidate="txtEmail" ValidationExpression="\w+([-+.']\w+)*@\w+([-.]\w+)*\.\w+([-.]\w+)*" Display="Dynamic" CssClass="ErrorText" ErrorMessage="Invalid Email"></asp:RegularExpressionValidator></td>
        </tr>
        <tr>
            <th></th>
            <td><div style="float:right"><Telerik:RadSpell ID="rspNotes" runat="server" ButtonType="ImageButton" ButtonText=" " FragmentIgnoreOptions="All" ControlToCheck="txtNotes" DictionaryLanguage="en-us" SupportedLanguages="en-US,English" /></div></td>
            <td></td>
        </tr>
        <tr>
            <th style="vertical-align:top"><label for="">Notes:</label></th>
            <td><asp:TextBox ID="txtNotes" runat="server" TextMode="MultiLine"></asp:TextBox></td>
            <td></td>
        </tr>
        <tr>
            <th><label>Status:</label></th>
            <td>
                <Telerik:RadComboBox ID="rcbStatus" runat="server">
                    <Items>
                        <Telerik:RadComboBoxItem Text="Active" Value="1" />
                        <Telerik:RadComboBoxItem Text="Inactive" Value="0" />
                    </Items>
                </Telerik:RadComboBox>
            </td>
        </tr>
            
        <uc:Contacts id="ucContacts" runat="server" />

        <tr>
            <th></th>
            <td>
                <div class="Form_Buttons">
                    <asp:Button ID="btnCancel" runat="server" Text="Cancel" CausesValidation="false" OnClick="Cancel_OnClick" />
                    <asp:Button ID="btnSave" runat="server" Text="Save" OnClick="btnSave_Click" />
                </div>
            </td>
        </tr>
    </tbody>
</table>
</asp:Panel>

</asp:Content>
