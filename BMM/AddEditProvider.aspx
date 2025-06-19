<%@ Page Title="" Language="C#" MasterPageFile="~/Master.Master" AutoEventWireup="true" CodeBehind="AddEditProvider.aspx.cs" Inherits="BMM.AddEditProvider" %>
<%@ Register Src="Controls/UserControl_Contacts.ascx" TagName="Contacts" TagPrefix="uc" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
     <link href="CSS/ManageAddEdit.css" rel="stylesheet" type="text/css" />
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
<script type="text/javascript">

    window.onload = function () { SetValidators() };

    function FlatRateClick() {
        var FlatRateVal = document.getElementById('<%= regMRIMoney.ClientID %>');
        var PercentageVal = document.getElementById('<%= regMRICost.ClientID %>');

        ValidatorEnable(FlatRateVal, true);
        ValidatorEnable(PercentageVal, false);

        document.getElementById('<%= hdnValidator.ClientID %>').value = "1";
    }

    function PercentageClick() {
        var FlatRateVal = document.getElementById('<%= regMRIMoney.ClientID %>');
        var PercentageVal = document.getElementById('<%= regMRICost.ClientID %>');

        ValidatorEnable(FlatRateVal, false);
        ValidatorEnable(PercentageVal, true);

        document.getElementById('<%= hdnValidator.ClientID %>').value = "2";
    }

    function SetValidators() {
        var valDator = document.getElementById('<%= hdnValidator.ClientID %>').value;

        if (valDator == "1")
            FlatRateClick();
        else if (valDator == "2")
            PercentageClick();
    }

</script>

<h1><asp:Literal ID="litHeader" runat="server"></asp:Literal></h1>

<asp:Panel ID="Panel1" runat="server" DefaultButton="btnSave" >
    <asp:HiddenField ID="hdnValidator" runat="server" />
    <table class="Form FormPadding" cellpadding="0" cellspacing="0">
        <tbody>
            <tr>
                <th><label for='<%= txtName.ClientID %>' >* Name:</label></th>
                <td><asp:TextBox ID="txtName" runat="server" MaxLength="100"></asp:TextBox></td>
                <td><asp:RequiredFieldValidator ID="rfvName" runat="server" ControlToValidate="txtName" Display="Dynamic" CssClass="ErrorText" ErrorMessage="Required"></asp:RequiredFieldValidator></td>
            </tr>
            <tr>
                <th><h2>Physical Address:</h2></th>
                <td></td>
                <th><h2>Billing Address:</h2></th>
            </tr>
            <tr>
               <%--<th><label for='<%= txtStreet1.ClientID %>'>* Street:</label></th>
                <td><asp:TextBox ID="txtStreet1" runat="server" MaxLength="100"></asp:TextBox></td>
                <td><asp:RequiredFieldValidator ID="RequiredFieldValidator1" runat="server" ControlToValidate="txtStreet1" Display="Dynamic" CssClass="ErrorText" ErrorMessage="Required"></asp:RequiredFieldValidator></td>

                <th><label for='<%= txtStreet1.ClientID %>'>* Street:</label></th>
                <td><asp:TextBox ID="TextBox1" runat="server" MaxLength="100"></asp:TextBox></td>
                <td><asp:RequiredFieldValidator ID="RequiredFieldValidator2" runat="server" ControlToValidate="txtStreet1" Display="Dynamic" CssClass="ErrorText" ErrorMessage="Required"></asp:RequiredFieldValidator></td>--%>
                            
                <th><label for='<%= txtStreet1.ClientID %>'>* Street:</label></th>
                <td>
                    <asp:TextBox ID="txtStreet1" runat="server" MaxLength="100"></asp:TextBox>
                    <asp:RequiredFieldValidator ID="RequiredFieldValidator7" runat="server" ControlToValidate="txtStreet1" Display="Dynamic" CssClass="ErrorText" ErrorMessage="Required"></asp:RequiredFieldValidator>
                </td>
                <th><label for='<%= txtStreet1_Billing.ClientID %>'>Street:</label></th>
                <td>
                    <asp:TextBox ID="txtStreet1_Billing" runat="server" MaxLength="100"></asp:TextBox>
                </td>                
            </tr>
            <tr>
                <%--<th><label for='<%= txtStreet2.ClientID %>'>Apt or Suite:</label></th>
                <td><asp:TextBox ID="txtStreet2" runat="server" MaxLength="100"></asp:TextBox></td>
                <td></td>--%>

                <th><label for='<%= txtStreet2.ClientID %>'>Apt or Suite:</label></th>
                <td>
                    <asp:TextBox ID="txtStreet2" runat="server" MaxLength="100"></asp:TextBox>
                </td>
                <th><label for='<%= txtStreet2_Billing.ClientID %>'>Apt or Suite:</label></th>
                <td>
                    <asp:TextBox ID="txtStreet2_Billing" runat="server" MaxLength="100"></asp:TextBox>
                </td>     
            </tr>
            <tr>
                <%--<th><label for='<%= txtCity.ClientID %>'>* City:</label></th>
                <td><asp:TextBox ID="txtCity" runat="server" MaxLength="100"></asp:TextBox></td>
                <td><asp:RequiredFieldValidator ID="RequiredFieldValidator3" runat="server" ControlToValidate="txtCity" Display="Dynamic" CssClass="ErrorText" ErrorMessage="Required"></asp:RequiredFieldValidator></td>--%>

                <th><label for='<%= txtCity.ClientID %>'>* City:</label></th>
                <td>
                    <asp:TextBox ID="txtCity" runat="server" MaxLength="100"></asp:TextBox>
                    <asp:RequiredFieldValidator ID="RequiredFieldValidator1" runat="server" ControlToValidate="txtCity" Display="Dynamic" CssClass="ErrorText" ErrorMessage="Required"></asp:RequiredFieldValidator>
                </td>
                <th><label for='<%= txtCity_Billing.ClientID %>'>City:</label></th>
                <td>
                    <asp:TextBox ID="txtCity_Billing" runat="server" MaxLength="100"></asp:TextBox>
                </td>  
            </tr>
            <tr>
                <%--<th><label>* State:</label></th>
                <td><Telerik:RadComboBox ID="rcbState" runat="server" EmptyMessage="Select"></Telerik:RadComboBox></td>
                <td><asp:RequiredFieldValidator ID="RequiredFieldValidator4" runat="server" ControlToValidate="rcbState" InitialValue="" Display="Dynamic" CssClass="ErrorText" ErrorMessage="Required"></asp:RequiredFieldValidator></td>--%>

                <th><label for='<%= rcbState.ClientID %>'>* State:</label></th>
                <td>
                    <Telerik:RadComboBox ID="rcbState" runat="server" EmptyMessage="Select"></Telerik:RadComboBox>
                    <asp:RequiredFieldValidator ID="RequiredFieldValidator2" runat="server" ControlToValidate="rcbState" InitialValue="" Display="Dynamic" CssClass="ErrorText" ErrorMessage="Required"></asp:RequiredFieldValidator>
                </td>
                <th><label for='<%= rcbState_Billing.ClientID %>'>State:</label></th>
                <td>
                    <Telerik:RadComboBox ID="rcbState_Billing" runat="server" EmptyMessage="Select"></Telerik:RadComboBox>
                </td>  
            </tr>
            <tr>
                <%--<th><label for='<%= txtZip.ClientID %>'>* Zip Code:</label></th>
                <td><asp:TextBox ID="txtZip" runat="server"></asp:TextBox></td>
                <td colspan="2">
                    <asp:RegularExpressionValidator ID="revZipCode" runat="server" ControlToValidate="txtZip" Display="Dynamic" CssClass="ErrorText" ErrorMessage="Invalid Zip Code" ValidationExpression="^\d{5}(-\d{4})?$"></asp:RegularExpressionValidator>
                    <asp:RequiredFieldValidator ID="RequiredFieldValidator5" runat="server" ControlToValidate="txtZip" Display="Dynamic" CssClass="ErrorText" ErrorMessage="Required"></asp:RequiredFieldValidator>
                </td>--%>

                <th><label for='<%= txtZip.ClientID %>'>* Zip Code:</label></th>
                <td>
                    <asp:TextBox ID="txtZip" runat="server"></asp:TextBox>
                    <asp:RegularExpressionValidator ID="revZipCode" runat="server" ControlToValidate="txtZip" Display="Dynamic" CssClass="ErrorText" ErrorMessage="Invalid Zip" ValidationExpression="^\d{5}(-\d{4})?$"></asp:RegularExpressionValidator>
                    <asp:RequiredFieldValidator ID="RequiredFieldValidator3" runat="server" ControlToValidate="txtZip" InitialValue="" Display="Dynamic" CssClass="ErrorText" ErrorMessage="Required"></asp:RequiredFieldValidator>
                </td>
                <th><label for='<%= txtZip_Billing.ClientID %>'>Zip Code:</label></th>
                <td>
                    <asp:TextBox ID="txtZip_Billing" runat="server"></asp:TextBox>
                    <asp:RegularExpressionValidator ID="revZipCode_Billing" runat="server" ControlToValidate="txtZip_Billing" Display="Dynamic" CssClass="ErrorText" ErrorMessage="Invalid Zip" ValidationExpression="^\d{5}(-\d{4})?$"></asp:RegularExpressionValidator>
                </td>
            </tr>
            <tr>
                <%--<th><label for='<%= txtPhone.ClientID %>'>* Phone:</label></th>
                <td><asp:TextBox ID="txtPhone" runat="server"></asp:TextBox></td>
                <td colspan="2">
                    <asp:RequiredFieldValidator ID="RequiredFieldValidator6" runat="server" ControlToValidate="txtPhone" Display="Dynamic" CssClass="ErrorText" ErrorMessage="Required"></asp:RequiredFieldValidator>
                </td>--%>

                <th><label for='<%= txtPhone.ClientID %>'>* Phone:</label></th>
                <td>
                    <asp:TextBox ID="txtPhone" runat="server" MaxLength="100"></asp:TextBox>
                    <asp:RequiredFieldValidator ID="RequiredFieldValidator4" runat="server" ControlToValidate="txtPhone" Display="Dynamic" CssClass="ErrorText" ErrorMessage="Required"></asp:RequiredFieldValidator>
                </td>
                <th><label for='<%= txtPhone_Billing.ClientID %>'>Phone:</label></th>
                <td>
                    <asp:TextBox ID="txtPhone_Billing" runat="server" MaxLength="100"></asp:TextBox>
                </td> 
            </tr>
            <tr>
                <%--<th><label for='<%= txtFax.ClientID %>'>Fax:</label></th>
                <td><asp:TextBox ID="txtFax" runat="server"></asp:TextBox></td>
                <td colspan="2"></td>--%>

                <th><label for='<%= txtFax.ClientID %>'>Fax:</label></th>
                <td>
                    <asp:TextBox ID="txtFax" runat="server" MaxLength="100"></asp:TextBox>
                </td>
                <th><label for='<%= txtFax_Billing.ClientID %>'>Fax:</label></th>
                <td>
                    <asp:TextBox ID="txtFax_Billing" runat="server" MaxLength="100"></asp:TextBox>
                </td> 
            </tr>
            <tr>
                <%--<th><label for='<%= txtEmail.ClientID %>'>Email Address:</label></th>
                <td><asp:TextBox ID="txtEmail" runat="server"></asp:TextBox></td>
                <td><asp:RegularExpressionValidator ID="RegularExpressionValidator1" runat="server" ControlToValidate="txtEmail" ValidationExpression="\w+([-+.']\w+)*@\w+([-.]\w+)*\.\w+([-.]\w+)*" Display="Dynamic" CssClass="ErrorText" ErrorMessage="Invalid Email"></asp:RegularExpressionValidator></td>--%>
            
                <th><label for='<%= txtEmail.ClientID %>'>Email Address:</label></th>
                <td>
                    <asp:TextBox ID="txtEmail" runat="server" MaxLength="100"></asp:TextBox>
                    <asp:RegularExpressionValidator ID="RegularExpressionValidator4" runat="server" ControlToValidate="txtEmail" ValidationExpression="\w+([-+.']\w+)*@\w+([-.]\w+)*\.\w+([-.]\w+)*" Display="Dynamic" CssClass="ErrorText" ErrorMessage="Invalid"></asp:RegularExpressionValidator>
                </td>
                <th><label for='<%= txtEmail_Billing.ClientID %>'>Email Address:</label></th>
                <td>
                    <asp:TextBox ID="txtEmail_Billing" runat="server" MaxLength="100"></asp:TextBox>
                    <asp:RegularExpressionValidator ID="RegularExpressionValidator5" runat="server" ControlToValidate="txtEmail_Billing" ValidationExpression="\w+([-+.']\w+)*@\w+([-.]\w+)*\.\w+([-.]\w+)*" Display="Dynamic" CssClass="ErrorText" ErrorMessage="Invalid"></asp:RegularExpressionValidator>
                </td> 
            </tr>
            <tr>
                <th></th>
                <td><div style="float:right"><Telerik:RadSpell ID="rspNotes" TabIndex="14" runat="server" ButtonType="ImageButton" ButtonText=" " FragmentIgnoreOptions="All" ControlToCheck="txtNotes" DictionaryLanguage="en-us" SupportedLanguages="en-US,English" /></div></td>
            </tr>
            <tr>
                <th style="vertical-align:top"><label for='<%= txtNotes.ClientID %>'>Notes</label></th>
                <td><asp:TextBox ID="txtNotes" runat="server" TextMode="MultiLine"></asp:TextBox></td>

                <th style="vertical-align:top"><label for='<%= txtTaxID.ClientID %>'>* Tax ID #:</label></th>
                <td style="vertical-align:top">
                    <asp:TextBox ID="txtTaxID" runat="server" MaxLength="100"></asp:TextBox>
                    <asp:RequiredFieldValidator ID="RequiredFieldValidator5" runat="server" ControlToValidate="txtTaxID" Display="Dynamic" CssClass="ErrorText" ErrorMessage="Required"></asp:RequiredFieldValidator>
                </td>
            </tr>
            <tr>
                <th><label>Status</label></th>
                <td>
                    <Telerik:RadComboBox ID="rcbStatus" runat="server">
                        <Items>
                            <Telerik:RadComboBoxItem Text="Active" Value="1" />
                            <Telerik:RadComboBoxItem Text="Inactive" Value="0" />
                        </Items>
                    </Telerik:RadComboBox>
                </td>
            </tr>
            <tr>
                <th><label for='<%= txtFacilityAbbreviation.ClientID %>'>Facility Abbreviation:</label></th>
                <td><asp:TextBox ID="txtFacilityAbbreviation" runat="server" MaxLength="50"></asp:TextBox></td>
                <td></td>
            </tr>
            <tr>
                <th><label for='<%= txtDiscountPercentage.ClientID %>'>Discount Percentage:</label></th>
                <td><asp:TextBox ID="txtDiscountPercentage" runat="server"></asp:TextBox></td>
                <td colspan="2"><asp:RegularExpressionValidator ID="RegularExpressionValidator2" runat="server" ControlToValidate="txtDiscountPercentage" Display="Dynamic" CssClass="ErrorText" ErrorMessage="Invalid Discount Percentage." ValidationExpression="^\d+(\.\d{1,2})?(%)?$"></asp:RegularExpressionValidator></td>
            </tr>
            <tr>
                <th><label>Alternative Discount:</label></th>
                <td>
                    <asp:RadioButton ID="rdoFlatRate" onmousedown="FlatRateClick()" runat="server" GroupName="MRI" Text="Flat Rate" Checked="true" />
                    <asp:RadioButton ID="rdoPercentage" onmousedown="PercentageClick()" runat="server" GroupName="MRI" Text="Percentage" />
                </td>
                <td></td>
            </tr>
            <tr>
                <th></th>
                <td><asp:TextBox ID="txtMRICost" runat="server" MaxLength="50"></asp:TextBox></td>
                <td colspan="2">
                    <asp:RegularExpressionValidator ID="regMRIMoney" runat="server" ControlToValidate="txtMRICost" Display="Dynamic" CssClass="ErrorText" ErrorMessage="Invalid MRI Cost Amount" ValidationExpression="^\$?[0-9]+(,[0-9]{3})*(\.[0-9]{2})?$"></asp:RegularExpressionValidator>
                    <asp:RegularExpressionValidator ID="regMRICost" runat="server" ControlToValidate="txtMRICost" Display="Dynamic" CssClass="ErrorText" ErrorMessage="Invalid MRI Cost Percentage" ValidationExpression="^\d+(\.\d{1,2})?(%)?$"></asp:RegularExpressionValidator>
                </td>
            </tr>
            <tr>
                <th><label for='<%= txtDeposits.ClientID %>'>Deposits:</label></th>
                <td><asp:TextBox ID="txtDeposits" runat="server" MaxLength="50"></asp:TextBox></td>
                <td colspan="2"><asp:RegularExpressionValidator ID="regDeposits" runat="server" ControlToValidate="txtDeposits" Display="Dynamic" CssClass="ErrorText" ErrorMessage="Invalid Deposit Amount" ValidationExpression="^\$?[0-9]+(,[0-9]{3})*(\.[0-9]{2})?$"></asp:RegularExpressionValidator></td>
            </tr>
            <tr>
                <th><label for='<%= txtDaysUntilPaymentDue.ClientID %>'>Days Until Payment Due:</label></th>
                <td><asp:TextBox ID="txtDaysUntilPaymentDue" runat="server" MaxLength="50"></asp:TextBox></td>
                <td colspan="2"><asp:RegularExpressionValidator ID="RegularExpressionValidator3" runat="server" ControlToValidate="txtDaysUntilPaymentDue" Display="Dynamic" CssClass="ErrorText" ErrorMessage="Invalid Amount of Days" ValidationExpression="^\d+$"></asp:RegularExpressionValidator></td>
            </tr>
            
            <uc:Contacts id="ucContacts" runat="server" />

            <tr>
                <th></th>
                <td>
                    <div class="Form_Buttons" >
                        <asp:Button ID="btnCancel" runat="server" Text="Cancel" OnClick="btnCancel_OnClick" CausesValidation="false" />
                        <asp:Button ID="btnSave" runat="server" Text="Save" OnClick="btnSave_Click" />
                    </div>
                </td>
            </tr>
            
        </tbody>
    </table>
</asp:Panel>

</asp:Content>
