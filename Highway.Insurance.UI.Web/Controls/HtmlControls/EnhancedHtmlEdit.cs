﻿using Microsoft.VisualStudio.TestTools.UITesting.HtmlControls;

namespace Highway.Insurance.UI.Web.Controls.HtmlControls
{
    public class EnhancedHtmlEdit : EnhancedHtmlControl<HtmlEdit>
    {
        public EnhancedHtmlEdit() : base() { }
        public EnhancedHtmlEdit(string searchParameters) : base(searchParameters) { }
        public EnhancedHtmlEdit(WebPage page, string selector) : base(page, selector) { }
        public EnhancedHtmlEdit(HtmlEdit control) : base(control) { }

        public void SetText(string sText)
        {
            this._control.WaitForControlReady();
            this._control.Text = sText;
        }

        public string GetText()
        {
            this._control.WaitForControlReady();
            return this._control.Text; 
        }

        public bool ReadOnly
        {
            get
            {
                this._control.WaitForControlReady();
                return this._control.ReadOnly;
            }
        }
    }
}
