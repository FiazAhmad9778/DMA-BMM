<%@ Page Title="" Language="C#" MasterPageFile="~/Master.Master" AutoEventWireup="true" CodeBehind="LoanTerms.aspx.cs" Inherits="BMM.LoanTerms" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <link href="CSS/ManageAddEdit.css" rel="stylesheet" type="text/css" />
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <h1>Loan Terms</h1>
    <div id="ManageLoanTermsDiv">
        <asp:Panel ID="pnlDefaultButton" runat="server" DefaultButton="btnSave">
            <div class="PrefaceText">
                Note, when Loan Terms are changed, existing invoices will retain the Loan Terms applied to the invoice when it was created. All new invoices created will have the new Loan Terms applied to them.<br /><br /><br />
            </div>                
            <div>
                Testing Invoices:<br /><br />            
                <div>
                    Yearly Interest:&nbsp;
                    <asp:TextBox runat="server" ID="txtTestLoanIntrest" Width="75px"></asp:TextBox>&nbsp;&nbsp;
                    <asp:RequiredFieldValidator runat="server" ID="rfvTestLoanIntrest" ControlToValidate="txtTestLoanIntrest" CssClass="ErrorText" Display="Dynamic" ErrorMessage="Required"/>
                    <asp:RegularExpressionValidator runat="server" ID="revTestLoanInterest" ControlToValidate="txtTestLoanIntrest" ValidationExpression="^\s*(\d{0,2})(\.?(\d{0,2}))?\s*\%?\s*$" CssClass="ErrorText" Display="Dynamic" ErrorMessage="Value entered must be a numeric value."/>
                    <br /><br />
                </div>
                <div>
                    Loan Term (in months):&nbsp;
                    <asp:TextBox runat="server" ID="txtTestLoanTerm" Width="75px"></asp:TextBox>&nbsp;
                    <asp:RequiredFieldValidator runat="server" ID="rfvTestLoanTerm" ControlToValidate="txtTestLoanTerm" CssClass="ErrorText" Display="Dynamic" ErrorMessage="Required" />
                    <asp:RegularExpressionValidator runat="server" ID="revTestLoanTerm" ControlToValidate="txtTestLoanTerm" ValidationExpression="^([0-9]*|\d*)$" CssClass="ErrorText" Display="Dynamic" ErrorMessage="Value entered must be a numeric value."/>
                    <br /><br />
                </div>
                <div>
                    Interest Waived Time Period (in months):&nbsp;
                    <asp:TextBox runat="server" ID="txtTestFeeWaivedTime" Width="75px"></asp:TextBox>&nbsp;&nbsp;
                    <asp:RequiredFieldValidator runat="server" ID="rfvTestFeeWaivedTime" ControlToValidate="txtTestFeeWaivedTime" CssClass="ErrorText" Display="Dynamic" ErrorMessage="Required" />
                    <asp:RegularExpressionValidator runat="server" ID="revTestFeeWaivedTime" ControlToValidate="txtTestFeeWaivedTime" ValidationExpression="^([0-9]*|\d*)$" CssClass="ErrorText" Display="Dynamic" ErrorMessage="Value entered must be a numeric value."/>
                    <br /><br />
                </div>
            </div>
            <br /><br />
            <div>
                Surgery Invoices:<br /><br />      
                <div>
                    Yearly Interest:&nbsp;
                    <asp:TextBox runat="server" ID="txtSurgeryLoanIntrest" Width="75px"></asp:TextBox>&nbsp;&nbsp;
                    <asp:RequiredFieldValidator runat="server" ID="rfvSurgeryLoanInterest" ControlToValidate="txtSurgeryLoanIntrest" CssClass="ErrorText" Display="Dynamic" ErrorMessage="Required"/>
                    <asp:RegularExpressionValidator runat="server" ID="revSurgeryLoanInterest" ControlToValidate="txtSurgeryLoanIntrest" ValidationExpression="^\s*(\d{0,2})(\.?(\d{0,2}))?\s*\%?\s*$" CssClass="ErrorText" Display="Dynamic" ErrorMessage="Value entered must be a numeric value."/>
                    <br /><br />
                </div>
                <div>
                    Loan Term (in months):&nbsp;
                    <asp:TextBox runat="server" ID="txtSurgeryLoanTerm" Width="75px"></asp:TextBox>&nbsp;&nbsp;
                    <asp:RequiredFieldValidator runat="server" ID="rfvSurgeryLoanTerm" ControlToValidate="txtSurgeryLoanTerm" CssClass="ErrorText" Display="Dynamic" ErrorMessage="Required"/>
                    <asp:RegularExpressionValidator runat="server" ID="revSurgeryLoanTerm" ControlToValidate="txtSurgeryLoanTerm" ValidationExpression="^([0-9]*|\d*)$" CssClass="ErrorText" Display="Dynamic" ErrorMessage="Value entered must be a numeric value."/>
                    <br /><br />
                </div>
                <div>
                    Interest Waived Time Period (in months):&nbsp;
                    <asp:TextBox runat="server" ID="txtSurgeryFeeWaivedTime" Width="75px"></asp:TextBox>&nbsp;&nbsp;
                    <asp:RequiredFieldValidator runat="server" ID="rfvSurgeryFeeWaivedTime" ControlToValidate="txtSurgeryFeeWaivedTime" CssClass="ErrorText" Display="Dynamic" ErrorMessage="Required" />
                    <asp:RegularExpressionValidator runat="server" ID="revSurgeryFeeWaivedTime" ControlToValidate="txtSurgeryFeeWaivedTime" ValidationExpression="^([0-9]*|\d*)$" CssClass="ErrorText" Display="Dynamic" ErrorMessage="Value entered must be a numeric value."/>
                    <br /><br />
                </div>
                <br /><br />
                <div id="divSaveCancel">
                    <asp:Button ID="btnCancel" runat="server" Text="Cancel" OnClick="btnCancel_Click" CausesValidation="false" />&nbsp;&nbsp;
                    <asp:Button ID="btnSave" runat="server" Text="Save" OnClick="btnSave_Click" CausesValidation="true" />
                </div> 
            </div>  
        </asp:Panel>
    </div>  
</asp:Content>
