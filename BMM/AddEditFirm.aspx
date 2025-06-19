<%@ Page Title="" Language="C#" MasterPageFile="~/Master.Master" AutoEventWireup="true" CodeBehind="AddEditFirm.aspx.cs" Inherits="BMM.AddEditFirm" %>
<%@ Register Src="Controls/UserControl_Contacts.ascx" TagName="Contacts" TagPrefix="uc" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
<link href="CSS/ManageAddEdit.css" rel="stylesheet" type="text/css" />
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
<h1><asp:Literal ID="litHeader" runat="server"></asp:Literal></h1>
<asp:Panel ID="Panel1" runat="server" DefaultButton="btnSave">
<div style="float:left">
<table class="Form FormPadding" cellpadding="0" cellspacing="0">
    <tr>
        <th><label for='<%= txtName.ClientID %>'>* Name</label></th>
        <td><asp:TextBox ID="txtName" runat="server" MaxLength="100"></asp:TextBox></td>
        <td><asp:RequiredFieldValidator ID="rfvName" runat="server" ControlToValidate="txtName" CssClass="ErrorText" Display="Dynamic" ErrorMessage="Required"></asp:RequiredFieldValidator></td>
    </tr>
    <tr>
        <th><h2>Address:</h2></th>
        <td></td>
        <td></td>
    </tr>
    <tr>
        <th><label for='<%= txtStreet.ClientID %>'>* Street:</label></th>
        <td><asp:TextBox ID="txtStreet" runat="server" MaxLength="100"></asp:TextBox></td>
        <td colspan="2"><asp:RequiredFieldValidator ID="rfvStreet" runat="server" ControlToValidate="txtStreet" CssClass="ErrorText" Display="Dynamic" ErrorMessage="Required"></asp:RequiredFieldValidator></td>
    </tr>
    <tr>
        <th><label for='<%= txtAptSuite.ClientID %>'>Apt or Suite:</label></th>
        <td><asp:TextBox ID="txtAptSuite" runat="server" MaxLength="100"></asp:TextBox></td>
        <td></td>
    </tr>
    <tr>
        <th><label for='<%= txtCity.ClientID %>'>* City:</label></th>
        <td><asp:TextBox ID="txtCity" runat="server" MaxLength="100"></asp:TextBox></td>
        <td colspan="2"><asp:RequiredFieldValidator ID="rfvCity" runat="server" ControlToValidate="txtCity" CssClass="ErrorText" Display="Dynamic" ErrorMessage="Required"></asp:RequiredFieldValidator></td>
    </tr>
    <tr>
        <th><label>* State:</label></th>
        <td>
            <Telerik:RadComboBox ID="rcbState" runat="server" AppendDataBoundItems="true">
            </Telerik:RadComboBox>
        </td>
        <td colspan="2"><asp:RequiredFieldValidator ID="rfvState" runat="server" ControlToValidate="rcbState" InitialValue="" CssClass="ErrorText" Display="Dynamic" ErrorMessage="Required"></asp:RequiredFieldValidator></td>
    </tr>
    <tr>
        <th><label for='<%= txtZip.ClientID %>'>* Zip Code:</label></th>
        <td><asp:TextBox ID="txtZip" runat="server"></asp:TextBox></td>
        <td colspan="2">
            <asp:RegularExpressionValidator ID="revZipCode" runat="server" ControlToValidate="txtZip" Display="Dynamic" CssClass="ErrorText" ErrorMessage="Invalid Zip Code" ValidationExpression="^\d{5}(-\d{4})?$"></asp:RegularExpressionValidator>
            <asp:RequiredFieldValidator ID="rfvZip" runat="server" ControlToValidate="txtZip" CssClass="ErrorText" Display="Dynamic" ErrorMessage="Required"></asp:RequiredFieldValidator>
        </td>
    </tr>
    <tr>
        <th><label for='<%= txtPhone.ClientID %>'>* Phone:</label></th>
        <td><asp:TextBox ID="txtPhone" runat="server"></asp:TextBox></td>
        <td colspan="2">
            <asp:RequiredFieldValidator ID="rfvPhone" runat="server" ControlToValidate="txtPhone" CssClass="ErrorText" Display="Dynamic" ErrorMessage="Required"></asp:RequiredFieldValidator>
        </td>
    </tr>
    <tr>
        <th><label for='<%= txtFax.ClientID %>'>Fax:</label></th>
        <td><asp:TextBox ID="txtFax" runat="server"></asp:TextBox></td>
        <td colspan="2"</td>
    </tr>
    <tr>
        <th><label>Status:</label></th>
        <td>
            <Telerik:RadComboBox ID="rcbStats" runat="server">
                <Items>
                    <Telerik:RadComboBoxItem Text="Active" Value="1" />
                    <Telerik:RadComboBoxItem Text="Inactive" Value="0" />
                </Items>
            </Telerik:RadComboBox>
        </td>
        <td></td>
    </tr>
    <uc:Contacts id="ucContacts" runat="server" />
    <tr>
        <th></th>
        <td>
            <div class="Form_Buttons">
                <asp:Button ID="btnCancel" OnClick="btnCancel_Click" runat="server" Text="Cancel" CausesValidation="false" />
                <asp:Button ID="btnSave" runat="server" Text="Save" OnClick="btnSave_Click" />
            </div>
        </td>
    </tr>
</table>
</div>
<div id="divAttorneys" runat="server" style="float: right">
<h2>Attorneys in Firm:</h2>
    <Telerik:RadGrid ID="grdAttorneys" runat="server" AllowPaging="true" PageSize="10" Width="200px" OnNeedDataSource="grdAttorneys_NeedDataSource" >
        <MasterTableView>
            <Columns>
                <Telerik:GridTemplateColumn HeaderText="Attorneys" HeaderStyle-HorizontalAlign="Center">
                    <ItemStyle HorizontalAlign="Center" />
                    <ItemTemplate>
                        <%# GetAttorneyLink(Eval("FirstName").ToString() + " " + Eval("LastName").ToString(), (int)Eval("ID"))%>
                    </ItemTemplate>
                </Telerik:GridTemplateColumn>
            </Columns>
        </MasterTableView>
    </Telerik:RadGrid>
</div>
</asp:Panel>
</asp:Content>
