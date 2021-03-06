﻿using Microsoft.VisualStudio.TestTools.UITesting.HtmlControls;

namespace Highway.Insurance.UI.Web.Controls.HtmlControls
{
    public class EnhancedHtmlVideo : EnhancedHtmlControl<HtmlVideo>
    {
        public EnhancedHtmlVideo() : base() { }
        public EnhancedHtmlVideo(string sSearchProperties) : base(sSearchProperties) { }
        public EnhancedHtmlVideo(WebPage page, string selector) : base(page, selector) { }
        public EnhancedHtmlVideo(HtmlVideo control) : base(control) { }
    }
}