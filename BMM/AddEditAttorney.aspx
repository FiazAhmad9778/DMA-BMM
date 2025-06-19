<%@ Page Title="" Language="C#" MasterPageFile="~/Master.Master" AutoEventWireup="true" CodeBehind="AddEditAttorney.aspx.cs" Inherits="BMM.AddEditAttorney" %>
<%@ Register Src="Controls/UserControl_Contacts.ascx" TagName="Contacts" TagPrefix="uc" %>
<%@ Register Src="Controls/UserControl_AttorneyTerms.ascx" TagName="AttorneyTerms" TagPrefix="uc2" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <link href="CSS/ManageAddEdit.css" rel="stylesheet" type="text/css" />
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
<script type="text/javascript">


</script>
<h1><asp:Literal ID="litHeader" runat="server"></asp:Literal></h1>
<asp:Panel ID="Panel1" runat="server" DefaultButton="btnSave">
    <table class="Form FormPadding" cellpadding="0" cellspacing="0">
        <tbody>
            <tr>
                <th><label for='<%= txtFirstName.ClientID %>'>* First Name:</label></th>
                <td><asp:TextBox TabIndex="1" ID="txtFirstName" runat="server" MaxLength="100"></asp:TextBox></td>
                <td style="width:115px"><asp:RequiredFieldValidator ID="rfvFirstName" runat="server" ControlToValidate="txtFirstName" Display="Dynamic" ErrorMessage="Required" CssClass="ErrorText"></asp:RequiredFieldValidator></td>
            </tr>
            <tr>
                <th><label for='<%= txtLastName.ClientID %>'>* Last Name:</label></th>
                <td><asp:TextBox TabIndex="2" ID="txtLastName" runat="server" MaxLength="100"></asp:TextBox></td>
                <td><asp:RequiredFieldValidator ID="rfvLastName" runat="server" ControlToValidate="txtLastName" Display="Dynamic" ErrorMessage="Required" CssClass="ErrorText"></asp:RequiredFieldValidator></td>
            </tr>
            <tr>
                <th><h2>Address:</h2></th>
                <td></td>
                <td></td>

            </tr>
            <tr>
                <th><label for='<%= txtStreet1.ClientID %>'>* Street:</label></th>
                <td><asp:TextBox TabIndex="3" ID="txtStreet1" runat="server" MaxLength="100"></asp:TextBox></td>
                <td><asp:RequiredFieldValidator ID="rfvStreet1" runat="server" ControlToValidate="txtStreet1" Display="Dynamic" ErrorMessage="Required" CssClass="ErrorText"></asp:RequiredFieldValidator></td>
            
            </tr>
            <tr>
                <th><label for='<%= txtStreet2.ClientID %>'>Apt or Suite:</label></th>
                <td><asp:TextBox TabIndex="4" ID="txtStreet2" runat="server" MaxLength="100"></asp:TextBox></td>
                <td></td>
            </tr>
            <tr>
                <th><label for='<%= txtCity.ClientID %>'>* City:</label></th>
                <td><asp:TextBox TabIndex="5" ID="txtCity" runat="server" MaxLength="100"></asp:TextBox></td>
                <td><asp:RequiredFieldValidator ID="rfvCity" runat="server" ControlToValidate="txtCity" Display="Dynamic" ErrorMessage="Required" CssClass="ErrorText"></asp:RequiredFieldValidator></td>                
            </tr>
            <tr>
                <th><label>* State:</label></th>
                <td>
                    <Telerik:RadComboBox TabIndex="6" ID="rcbState" MaxHeight="250px" runat="server" AppendDataBoundItems="true">
                        <Items>
                        </Items>
                    </Telerik:RadComboBox>
                </td>
                <td><asp:RequiredFieldValidator ID="rfvState" runat="server" ControlToValidate="rcbState" InitialValue="" Display="Dynamic" ErrorMessage="Required" CssClass="ErrorText"></asp:RequiredFieldValidator></td>
            

            </tr>
            <tr>
                <th><label for='<%= txtZip.ClientID %>'>* Zip Code:</label></th>
                <td><asp:TextBox TabIndex="7" ID="txtZip" runat="server" MaxLength="50"></asp:TextBox></td>
                <td>
                    <asp:RequiredFieldValidator ID="rfvZip" runat="server" ControlToValidate="txtZip" Display="Dynamic" ErrorMessage="Required" CssClass="ErrorText"></asp:RequiredFieldValidator>
                    <asp:RegularExpressionValidator ID="revZipCode" runat="server" ControlToValidate="txtZip" Display="Dynamic" CssClass="ErrorText" ErrorMessage="Invalid Zip Code" ValidationExpression="^\d{5}(-\d{4})?$"></asp:RegularExpressionValidator>
                </td>
            </tr>
            <tr>
                <th><label for='<%= txtPhone.ClientID %>'>* Phone:</label></th>
                <td><asp:TextBox TabIndex="8" ID="txtPhone" runat="server"></asp:TextBox></td>
                <td>
                    <asp:RequiredFieldValidator ID="RequiredFieldValidator1" runat="server" ControlToValidate="txtPhone" Display="Dynamic" ErrorMessage="Required" CssClass="ErrorText"></asp:RequiredFieldValidator>
                </td>           
            </tr>
            <tr>
                <th><label for='<%= txtFax.ClientID %>'>Fax:</label></th>
                <td><asp:TextBox TabIndex="9" ID="txtFax" runat="server"></asp:TextBox></td>
                <td></td>
            </tr>
            <tr>              
                <th><label for='<%= txtEmail.ClientID %>'>Email:</label></th>
                <td><asp:TextBox TabIndex="10" ID="txtEmail" runat="server" MaxLength="100"></asp:TextBox></td>
                <td><asp:RegularExpressionValidator ID="RegularExpressionValidator3" runat="server" ControlToValidate="txtEmail" ValidationExpression="\w+([-+.']\w+)*@\w+([-.]\w+)*\.\w+([-.]\w+)*" Display="Dynamic" CssClass="ErrorText" ErrorMessage="Invalid Email." ValidationGroup="Contact"></asp:RegularExpressionValidator></td>
            </tr>
            <tr>
                <th></th>
                <td><div style="float:right"><Telerik:RadSpell ID="rspNotes" TabIndex="11" runat="server" ButtonType="ImageButton" ButtonText=" " FragmentIgnoreOptions="All" ControlToCheck="txtNotes" DictionaryLanguage="en-us" SupportedLanguages="en-US,English" /></div></td>
                <td></td>
            </tr>
            <tr>
                <th class="Top"><label for='<%= txtNotes.ClientID %>'>Notes:</label></th>
                <td><asp:TextBox TabIndex="12" ID="txtNotes" TextMode="MultiLine" runat="server"></asp:TextBox></td>
                <td style="width:90px"></td>
            </tr>
            <tr>
                <th><label>Status:</label></th>
                <td>
                    <Telerik:RadComboBox id="rcbStatus" TabIndex="13" runat="server">
                        <Items>
                            <Telerik:RadComboBoxItem Text="Active" Value="1" />
                            <Telerik:RadComboBoxItem Text="Inactive" Value="0" />
                        </Items>
                    </Telerik:RadComboBox>
                </td>
                <td><asp:RequiredFieldValidator ID="rfvStatus" runat="server" ControlToValidate="rcbStatus" InitialValue="" Display="Dynamic" ErrorMessage="Required" CssClass="ErrorText"></asp:RequiredFieldValidator></td>
            </tr>
            <tr>
                <th></th>
                <td><div style="float:right"><Telerik:RadSpell ID="rspDiscount" TabIndex="14" runat="server" ButtonType="ImageButton" ButtonText=" " FragmentIgnoreOptions="All" ControlToCheck="txtDiscountNotes" DictionaryLanguage="en-us" SupportedLanguages="en-US,English" /></div></td>
                <td></td>
            </tr>
            <tr>
                <th class="Top"> <label>Discount Notes:</label></th>
                <td><asp:TextBox TextMode="MultiLine" TabIndex="15" ID="txtDiscountNotes" runat="server"></asp:TextBox></td>
                <td></td>              
            </tr>
            <tr>
                <th><label for='<%= txtDeposit.ClientID %>'>Deposit Amount Required:</label></th>
                <td><asp:TextBox ID="txtDeposit" TabIndex="16" runat="server"></asp:TextBox></td>
                <td><asp:RegularExpressionValidator ID="revDeposit" runat="server" ControlToValidate="txtDeposit" Display="Dynamic" ErrorMessage="Invalid Amount" CssClass="ErrorText" ValidationExpression="^(100|(\d{1,2})(\.\d{1,2}?)?)(%)?$"></asp:RegularExpressionValidator></td>                        
            </tr>
            <tr>
                <th><label>Firm:</label></th>
                <td>
                    <Telerik:RadComboBox ID="rcbFirm" TabIndex="17" MaxHeight="250px" AppendDataBoundItems="true" runat="server">
                        <Items>
                            <telerik:RadComboBoxItem Text="" Value="" />
                        </Items>
                    </Telerik:RadComboBox>
                </td>
                <td></td>                  
            </tr>
                <uc:Contacts id="ucContacts" runat="server" />
                <uc2:AttorneyTerms id="ucAttorneyTerms" runat="server" />
            <tr>
                <th></th>
                <td>
                    <div class="Form_Buttons">
                        <asp:Button ID="btnCancel" Text="Cancel" runat="server" CausesValidation="false" OnClick="btnCancel_Click" />
                        <asp:Button ID="btnSave" Text="Save" runat="server" CausesValidation="true" OnClick="btnSave_Click" />
                    </div>
                </td>
            </tr>
        </tbody>                    
    </table>
</asp:Panel>
</asp:Content>
