<%@ Page Title="" Language="C#" MasterPageFile="~/Master.Master" AutoEventWireup="true" CodeBehind="AddEditUsers.aspx.cs" Inherits="BMM.AddEditUsers" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
<link href="CSS/ManageAddEdit.css" rel="stylesheet" type="text/css" />
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">

<script type="text/javascript">
    //Enables the Comparison Validator for edit mode only when the password field is being edited.
    function ComparePasswords() {
        var txtPassword = document.getElementById('<%= txtPassword.ClientID %>');
        var valVerification = document.getElementById('<%= cpvVerifyPassword.ClientID %>');
        if (txtPassword.value.length > 0)
            ValidatorEnable(valVerification, true);
        else
            ValidatorEnable(valVerification, false);
    }
    //Additionally enables the required field validator for the verify password field 
    //once the password has been edited.
    function EnableRequiredField() {
        var txtPassword = document.getElementById('<%= txtPassword.ClientID %>');
        var rfvVerifyPassword = document.getElementById('<%= rfvVerifyPassword.ClientID %>');
        if (txtPassword.value.length > 0)
            ValidatorEnable(rfvVerifyPassword, true);
        else
            ValidatorEnable(rfvVerifyPassword, false);
    }

    function SetEnabled(btn, enabled) {
        Telerik.Web.UI.RadFormDecorator.set_enabled(btn, enabled);
    }

    function CheckInitialValues() {
        if (!$('#<%= chkInvoicesView.ClientID %>').prop("checked")) {
            $('tr.Invoice input:checkbox').attr('checked', false);
            $('tr.Invoice input:checkbox').each(function () { SetEnabled(this, false) });
            $('tr.InvoiceRow input:checkbox').attr('checked', false);
            $('tr.InvoiceRow input:checkbox').each(function () { SetEnabled(this, false) });
            $('#<%= chkInvoicesView.ClientID %>').attr('disabled', false);
        } else {
            $('span.FirstCheckBox input').each(function () {
                if (!$(this).prop("checked")) {

                    $(this).parent().next().children('input:checkbox').attr('checked', false);
                    SetEnabled($(this).parent().next().children('input:checkbox')[0], false);

                    $(this).parent().next().next().children('input:checkbox').attr('checked', false);
                    SetEnabled($(this).parent().next().next().children('input:checkbox')[0], false);

                    $(this).parent().next().next().next().children('input:checkbox').attr('checked', false);
                    SetEnabled($(this).parent().next().next().next().children('input:checkbox')[0], false);

                }
                else {
                    $(this).parent().next().children('input:checkbox').attr('disabled', false);
                    $(this).parent().next().next().children('input:checkbox').attr('disabled', false);
                    $(this).parent().next().next().next().children('input:checkbox').attr('disabled', false);
                }
            });
        }
    }


    $(document).ready(function () {

        CheckInitialValues();

        $('#<%= chkInvoicesView.ClientID %>').click(function () {
            if (!$(this).prop("checked")) {

                $('tr.Invoice input:checkbox').attr('checked', false);
                $('tr.Invoice input:checkbox').each(function () { SetEnabled(this, false) });
                $('tr.InvoiceRow input:checkbox').attr('checked', false);
                $('tr.InvoiceRow input:checkbox').each(function () { SetEnabled(this, false) });
                $(this).attr('disabled', false);
            }
            else {
                $('tr.Invoice input:checkbox').attr('disabled', false);
                $('span.FirstCheckBox input:checkbox').attr('disabled', false);
            }
        });

        $('span.FirstCheckBox input').click(function () {
            if (!$(this).prop("checked")) {

                $(this).parent().next().children('input:checkbox').attr('checked', false);
                SetEnabled($(this).parent().next().children('input:checkbox')[0], false);

                $(this).parent().next().next().children('input:checkbox').attr('checked', false);
                SetEnabled($(this).parent().next().next().children('input:checkbox')[0], false);

                $(this).parent().next().next().next().children('input:checkbox').attr('checked', false);
                SetEnabled($(this).parent().next().next().next().children('input:checkbox')[0], false);

            }
            else {
                $(this).parent().next().children('input:checkbox').attr('disabled', false);
                $(this).parent().next().next().children('input:checkbox').attr('disabled', false);
                $(this).parent().next().next().next().children('input:checkbox').attr('disabled', false);
            }
        });
    });
</script>

<h1><asp:Literal ID="litPageHeader" runat="server"></asp:Literal></h1>

    <asp:Panel ID="Panel1" runat="server" DefaultButton="btnSubmit">
        <table class="Form FormPadding" cellpadding="0" cellspacing="0">
            <tbody>
                <tr>
                    <th><label for="<%= txtFirstName.ClientID %>">* First Name:</label></th>
                    <td><asp:TextBox ID="txtFirstName" runat="server" MaxLength="100" ></asp:TextBox></td>
                    <td><asp:RequiredFieldValidator ID="rfvUsername" runat="server" ControlToValidate="txtFirstName" Display="Dynamic" CssClass="ErrorText" ErrorMessage="Required"></asp:RequiredFieldValidator></td>
                </tr>
                <tr>
                    <th><label for="<%= txtLastName.ClientID %>">* Last Name:</label></th>
                    <td><asp:TextBox ID="txtLastName" runat="server" MaxLength="100"></asp:TextBox></td>
                    <td><asp:RequiredFieldValidator ID="rfvLastName" runat="server" ControlToValidate="txtLastName" Display="Dynamic" CssClass="ErrorText" ErrorMessage="Required"></asp:RequiredFieldValidator></td>                    
                </tr>
                <tr>
                    <th><label for="<%= txtEmailAddress.ClientID %>">* Email Address:</label></th>
                    <td><asp:TextBox ID="txtEmailAddress" runat="server" MaxLength="100"></asp:TextBox></td>
                    <td>
                        <asp:RequiredFieldValidator ID="rfvEmailAddress" runat="server" ControlToValidate="txtEmailAddress" Display="Dynamic" CssClass="ErrorText" ErrorMessage="Required"></asp:RequiredFieldValidator>
                        <asp:RegularExpressionValidator ID="regEmail" runat="server" ControlToValidate="txtEmailAddress" ValidationExpression="\w+([-+.']\w+)*@\w+([-.]\w+)*\.\w+([-.]\w+)*" Display="Dynamic" CssClass="ErrorText" ErrorMessage="Please enter a valid Email Address."></asp:RegularExpressionValidator> 
                        <asp:CustomValidator ID="cvEmailAddress" runat="server" ControlToValidate="txtEmailAddress" Display="Dynamic" CssClass="ErrorText" onservervalidate="cvEmailAddress_ServerValidate" ErrorMessage="This Email Address is already taken."></asp:CustomValidator>
                    </td>                    
                </tr>
                <tr>
                    <th><label for="<%= txtPosition.ClientID %>">&nbsp;&nbsp;Position:</label></th>
                    <td><asp:TextBox ID="txtPosition" runat="server" MaxLength="100"></asp:TextBox></td>
                    <td></td>
                </tr>
                <tr>
                    <th><label for="<%= txtPassword.ClientID %>">* Password:</label></th>
                    <td><asp:TextBox ID="txtPassword" TextMode="Password" runat="server" MaxLength="100"></asp:TextBox></td>
                    <td><asp:RequiredFieldValidator ID="rfvPassword" runat="server" ControlToValidate="txtPassword" Display="Dynamic" CssClass="ErrorText" ErrorMessage="Required"></asp:RequiredFieldValidator></td>
                </tr>
                <tr>
                    <th><label for="<%= txtVerifyPassword.ClientID %>">* Verify Password:</label></th>
                    <td><asp:TextBox ID="txtVerifyPassword" TextMode="Password" runat="server" MaxLength="100"></asp:TextBox></td>
                    <td><asp:RequiredFieldValidator id="rfvVerifyPassword" runat="server" ControlToValidate="txtVerifyPassword" Display="Dynamic" CssClass="ErrorText" ErrorMessage="Required"></asp:RequiredFieldValidator>
                        <asp:CompareValidator ID="cpvVerifyPassword" runat="server" ControlToValidate="txtVerifyPassword" ControlToCompare="txtPassword" Display="Dynamic" CssClass="ErrorText" ErrorMessage="Passwords must match."></asp:CompareValidator>
                    </td>
                </tr>
            </tbody>
        </table>
        <h2 style="padding-top:15px;">Permissions:</h2>
        <table id="AddEditUsers_Permissions">
            <tbody>
                <tr class="Invoice">
                    <td>Invoices</td>
                    <td style="width: 300px">
                        <span class="FirstCheckBox"><asp:CheckBox ID="chkInvoicesView" runat="server" Text="View" /></span>
                        <span><asp:CheckBox ID="chkInvoicesAdd" runat="server" Text="Add" /></span>
                        <span><asp:CheckBox ID="chkInvoicesEdit" runat="server" Text="Edit" /></span>
                        <span><asp:CheckBox ID="chkInvoicesDelete" runat="server" Text="Delete" /></span>
                    </td>
                </tr>
                <tr class="InvoiceRow TestRow">
                    <td><div>Test</div></td>
                    <td>
                        <span class="FirstCheckBox"><asp:CheckBox ID="chkTestView" runat="server" Text="View" /></span>
                        <span><asp:CheckBox ID="chkTestAdd" runat="server" Text="Add" /></span>
                        <span><asp:CheckBox ID="chkTestEdit" runat="server" Text="Edit" /></span>
                        <span><asp:CheckBox ID="chkTestDelete" runat="server" Text="Delete" /></span>                        
                    </td>
                </tr>
                <tr class="InvoiceRow">
                    <td><div>Payment Information</div></td>
                    <td>
                        <span class="FirstCheckBox"><asp:CheckBox ID="chkPaymentInfoView" runat="server" Text="View" /></span>
                        <span><asp:CheckBox ID="chkPaymentInfoAdd" runat="server" Text="Add" /></span>
                        <span><asp:CheckBox ID="chkPaymentInfoEdit" runat="server" Text="Edit" /></span>
                        <span><asp:CheckBox ID="chkPaymentInfoDelete" runat="server" Text="Delete" /></span>  
                    </td>
                </tr>
                <tr class="InvoiceRow">
                    <td><div>Comments</div></td>
                    <td>
                        <span class="FirstCheckBox"><asp:CheckBox ID="chkCommentsView" runat="server" Text="View" /></span>
                        <span><asp:CheckBox ID="chkCommentsAdd" runat="server" Text="Add" /></span>
                        <span><asp:CheckBox ID="chkCommentsEdit" runat="server" Text="Edit" /></span>
                        <span><asp:CheckBox ID="chkCommentsDelete" runat="server" Text="Delete" /></span>  
                    </td>
                </tr>
                <tr class="InvoiceRow">
                    <td><div>Surgeries</div></td>
                    <td>
                        <span class="FirstCheckBox"><asp:CheckBox ID="chkSugeriesView" runat="server" Text="View" /></span>
                        <span><asp:CheckBox ID="chkSugeriesAdd" runat="server" Text="Add" /></span>
                        <span><asp:CheckBox ID="chkSugeriesEdit" runat="server" Text="Edit" /></span>
                        <span><asp:CheckBox ID="chkSugeriesDelete" runat="server" Text="Delete" /></span>  
                    </td>
                </tr>
                <tr class="InvoiceRow">
                    <td><div>Providers</div></td>
                    <td>
                        <span class="FirstCheckBox"><asp:CheckBox ID="chkProvidersView" runat="server" Text="View" /></span>
                        <span><asp:CheckBox ID="chkProvidersAdd" runat="server" Text="Add" /></span>
                        <span><asp:CheckBox ID="chkProvidersEdit" runat="server" Text="Edit" /></span>
                        <span><asp:CheckBox ID="chkProvidersDelete" runat="server" Text="Delete" /></span>  
                    </td>
                </tr>
                <tr>
                    <td>Patients</td>
                    <td>
                        <span class="FirstCheckBox"><asp:CheckBox ID="chkPatientsView" runat="server" Text="View" /></span>
                        <span><asp:CheckBox ID="chkPatientsAdd" runat="server" Text="Add" /></span>
                        <span><asp:CheckBox ID="chkPatientsEdit" runat="server" Text="Edit" /></span>
                        <span><asp:CheckBox ID="chkPatientsDelete" runat="server" Text="Delete" /></span>
                    </td>
                </tr>
                <tr>
                    <td>Admin Configuration</td>
                    <td>
                    </td>
                </tr>
                <tr>
                    <td><div>Firms</div></td>
                    <td>
                        <span class="FirstCheckBox"><asp:CheckBox ID="chkAdminFirmsView" runat="server" Text="View" /></span>
                        <span><asp:CheckBox ID="chkAdminFirmsAdd" runat="server" Text="Add" /></span>
                        <span><asp:CheckBox ID="chkAdminFirmsEdit" runat="server" Text="Edit" /></span>
                        <span><asp:CheckBox ID="chkAdminFirmsDelete" runat="server" Text="Delete" /></span>  
                    </td>
                </tr>
                <tr>
                    <td><div>Attorneys</div></td>
                    <td>
                        <span class="FirstCheckBox"><asp:CheckBox ID="chkAdminAttorneysView" runat="server" Text="View" /></span>
                        <span><asp:CheckBox ID="chkAdminAttorneysAdd" runat="server" Text="Add" /></span>
                        <span><asp:CheckBox ID="chkAdminAttorneysEdit" runat="server" Text="Edit" /></span>
                        <span><asp:CheckBox ID="chkAdminAttorneysDelete" runat="server" Text="Delete" /></span>  
                    </td>
                </tr>
                <tr>
                    <td><div>Providers</div></td>
                    <td>
                        <span class="FirstCheckBox"><asp:CheckBox ID="chkAdminProvidersView" runat="server" Text="View" /></span>
                        <span><asp:CheckBox ID="chkAdminProvidersAdd" runat="server" Text="Add" /></span>
                        <span><asp:CheckBox ID="chkAdminProvidersEdit" runat="server" Text="Edit" /></span>
                        <span><asp:CheckBox ID="chkAdminProvidersDelete" runat="server" Text="Delete" /></span>  
                    </td>
                </tr>
                <tr>
                    <td><div>Physicians</div></td>
                    <td>
                        <span class="FirstCheckBox"><asp:CheckBox ID="chkAdminPhysiciansView" runat="server" Text="View" /></span>
                        <span><asp:CheckBox ID="chkAdminPhysiciansAdd" runat="server" Text="Add" /></span>
                        <span><asp:CheckBox ID="chkAdminPhysiciansEdit" runat="server" Text="Edit" /></span>
                        <span><asp:CheckBox ID="chkAdminPhysiciansDelete" runat="server" Text="Delete" /></span>  
                    </td>
                </tr>
                <tr>
                    <td><div>CPT Codes</div></td>
                    <td>
                        <span class="FirstCheckBox"><asp:CheckBox ID="chkAdminCPTView" runat="server" Text="View" /></span>
                        <span><asp:CheckBox ID="chkAdminCPTAdd" runat="server" Text="Add" /></span>
                        <span><asp:CheckBox ID="chkAdminCPTEdit" runat="server" Text="Edit" /></span>
                        <span><asp:CheckBox ID="chkAdminCPTDelete" runat="server" Text="Delete" /></span>
                    </td>
                </tr>
                <tr>
                    <td><div>Procedures</div></td>
                    <td>
                        <span class="FirstCheckBox"><asp:CheckBox ID="chkAdminProceduresView" runat="server" Text="View" /></span>
                        <span><asp:CheckBox ID="chkAdminProceduresAdd" runat="server" Text="Add" /></span>
                        <span><asp:CheckBox ID="chkAdminProceduresEdit" runat="server" Text="Edit" /></span>
                        <span><asp:CheckBox ID="chkAdminProceduresDelete" runat="server" Text="Delete" /></span>
                    </td>
                </tr>
                <tr>
                    <td><div>Tests</div></td>
                    <td>
                        <span class="FirstCheckBox"><asp:CheckBox ID="chkAdminTestsView" runat="server" Text="View" /></span>
                        <span><asp:CheckBox ID="chkAdminTestsAdd" runat="server" Text="Add" /></span>
                        <span><asp:CheckBox ID="chkAdminTestsEdit" runat="server" Text="Edit" /></span>
                        <span><asp:CheckBox ID="chkAdminTestsDelete" runat="server" Text="Delete" /></span>
                    </td>
                </tr>
                <tr>
                    <td><div>Loan Terms</div></td>
                    <td>
                        <span class="FirstCheckBox"><asp:CheckBox ID="chkAdminLoanView" runat="server" Text="View" /></span>
                        <span><asp:CheckBox ID="chkAdminLoanAdd" runat="server" Text="Add" /></span>
                        <span><asp:CheckBox ID="chkAdminLoanEdit" runat="server" Text="Edit" /></span>
                        <span><asp:CheckBox ID="chkAdminLoanDelete" runat="server" Text="Delete" /></span>
                    </td>
                </tr>
                <tr>
                    <td><div>Users</div></td>
                    <td>
                        <span class="FirstCheckBox"><asp:CheckBox ID="chkAdminUsersView" runat="server" Text="View" /></span>
                        <span><asp:CheckBox ID="chkAdminUsersAdd" runat="server" Text="Add" /></span>
                        <span><asp:CheckBox ID="chkAdminUsersEdit" runat="server" Text="Edit" /></span>
                        <span><asp:CheckBox ID="chkAdminUsersDelete" runat="server" Text="Delete" /></span>
                    </td>
                </tr>
                <tr>
                    <td>Reports</td>
                    <td>
                        <span><asp:CheckBox ID="chkReportsView" runat="server" Text="View" /></span>
<%--                        <span><asp:CheckBox ID="chkReportsAdd" runat="server" Text="Add" /></span>
                        <span><asp:CheckBox ID="chkReportsEdit" runat="server" Text="Edit" /></span>
                        <span><asp:CheckBox ID="chkReportsDelete" runat="server" Text="Delete" /></span>  --%>                      
                    </td>
                </tr>
            </tbody>
        </table>

        <div class="Form_Buttons">
            <asp:Button ID="btnCancel" runat="server" Text="Cancel" OnClick="btnCancel_Click"  CausesValidation="false" />
            <asp:Button ID="btnSubmit" runat="server" Text="Save" OnClick="btnSubmit_Click" CausesValidation="true" />
        </div>
    </asp:Panel>
</asp:Content>
