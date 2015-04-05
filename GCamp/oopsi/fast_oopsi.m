




<!DOCTYPE html>
<html class="   ">
  <head prefix="og: http://ogp.me/ns# fb: http://ogp.me/ns/fb# object: http://ogp.me/ns/object# article: http://ogp.me/ns/article# profile: http://ogp.me/ns/profile#">
    <meta charset='utf-8'>
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    
    
    <title>oopsi/fast_oopsi.m at master · jovo/oopsi · GitHub</title>
    <link rel="search" type="application/opensearchdescription+xml" href="/opensearch.xml" title="GitHub" />
    <link rel="fluid-icon" href="https://github.com/fluidicon.png" title="GitHub" />
    <link rel="apple-touch-icon" sizes="57x57" href="/apple-touch-icon-114.png" />
    <link rel="apple-touch-icon" sizes="114x114" href="/apple-touch-icon-114.png" />
    <link rel="apple-touch-icon" sizes="72x72" href="/apple-touch-icon-144.png" />
    <link rel="apple-touch-icon" sizes="144x144" href="/apple-touch-icon-144.png" />
    <meta property="fb:app_id" content="1401488693436528"/>

      <meta content="@github" name="twitter:site" /><meta content="summary" name="twitter:card" /><meta content="jovo/oopsi" name="twitter:title" /><meta content="oopsi - up-to-date code for model-based inference of spike trains from calcium imaging" name="twitter:description" /><meta content="https://avatars1.githubusercontent.com/u/41842?s=400" name="twitter:image:src" />
<meta content="GitHub" property="og:site_name" /><meta content="object" property="og:type" /><meta content="https://avatars1.githubusercontent.com/u/41842?s=400" property="og:image" /><meta content="jovo/oopsi" property="og:title" /><meta content="https://github.com/jovo/oopsi" property="og:url" /><meta content="oopsi - up-to-date code for model-based inference of spike trains from calcium imaging" property="og:description" />

    <link rel="assets" href="https://assets-cdn.github.com/">
    <link rel="conduit-xhr" href="https://ghconduit.com:25035">
    

    <meta name="msapplication-TileImage" content="/windows-tile.png" />
    <meta name="msapplication-TileColor" content="#ffffff" />
    <meta name="selected-link" value="repo_source" data-pjax-transient />
      <meta name="google-analytics" content="UA-3769691-2">

    <meta content="collector.githubapp.com" name="octolytics-host" /><meta content="collector-cdn.github.com" name="octolytics-script-host" /><meta content="github" name="octolytics-app-id" /><meta content="80C551D4:4762:4F57978:5395B4E4" name="octolytics-dimension-request_id" />
    

    
    
    <link rel="icon" type="image/x-icon" href="https://assets-cdn.github.com/favicon.ico" />


    <meta content="authenticity_token" name="csrf-param" />
<meta content="cngJht+OVLbtOtPtiYrRj5j5D6Fd+ul88skgF9IBI1h8kWmOjWafFSdi4zngtJnKgLK2Az2ayTaFefiazOtH8A==" name="csrf-token" />

    <link href="https://assets-cdn.github.com/assets/github-1aeb426322c64c12b92d56bda5b110fc1093f75e.css" media="all" rel="stylesheet" type="text/css" />
    <link href="https://assets-cdn.github.com/assets/github2-b2cccfcac1a522b6ce675606f61388d36bf2c080.css" media="all" rel="stylesheet" type="text/css" />
    


    <meta http-equiv="x-pjax-version" content="6b9e40027b6fe719e1c3d0a9180a2d6a">

      
  <meta name="description" content="oopsi - up-to-date code for model-based inference of spike trains from calcium imaging" />

  <meta content="41842" name="octolytics-dimension-user_id" /><meta content="jovo" name="octolytics-dimension-user_login" /><meta content="2074979" name="octolytics-dimension-repository_id" /><meta content="jovo/oopsi" name="octolytics-dimension-repository_nwo" /><meta content="true" name="octolytics-dimension-repository_public" /><meta content="false" name="octolytics-dimension-repository_is_fork" /><meta content="2074979" name="octolytics-dimension-repository_network_root_id" /><meta content="jovo/oopsi" name="octolytics-dimension-repository_network_root_nwo" />
  <link href="https://github.com/jovo/oopsi/commits/master.atom" rel="alternate" title="Recent Commits to oopsi:master" type="application/atom+xml" />

  </head>


  <body class="logged_out  env-production windows vis-public page-blob">
    <a href="#start-of-content" tabindex="1" class="accessibility-aid js-skip-to-content">Skip to content</a>
    <div class="wrapper">
      
      
      
      


      
      <div class="header header-logged-out">
  <div class="container clearfix">

    <a class="header-logo-wordmark" href="https://github.com/">
      <span class="mega-octicon octicon-logo-github"></span>
    </a>

    <div class="header-actions">
        <a class="button primary" href="/join">Sign up</a>
      <a class="button signin" href="/login?return_to=%2Fjovo%2Foopsi%2Fblob%2Fmaster%2Ffast_oopsi.m">Sign in</a>
    </div>

    <div class="command-bar js-command-bar  in-repository">

      <ul class="top-nav">
          <li class="explore"><a href="/explore">Explore</a></li>
        <li class="features"><a href="/features">Features</a></li>
          <li class="enterprise"><a href="https://enterprise.github.com/">Enterprise</a></li>
          <li class="blog"><a href="/blog">Blog</a></li>
      </ul>
        <form accept-charset="UTF-8" action="/search" class="command-bar-form" id="top_search_form" method="get">

<div class="commandbar">
  <span class="message"></span>
  <input type="text" data-hotkey="s, /" name="q" id="js-command-bar-field" placeholder="Search or type a command" tabindex="1" autocapitalize="off"
    
    
      data-repo="jovo/oopsi"
      data-branch="master"
      data-sha="c6cbba184a5b34ebdd72b25f67df0bc89e839ff9"
  >
  <div class="display hidden"></div>
</div>

    <input type="hidden" name="nwo" value="jovo/oopsi" />

    <div class="select-menu js-menu-container js-select-menu search-context-select-menu">
      <span class="minibutton select-menu-button js-menu-target" role="button" aria-haspopup="true">
        <span class="js-select-button">This repository</span>
      </span>

      <div class="select-menu-modal-holder js-menu-content js-navigation-container" aria-hidden="true">
        <div class="select-menu-modal">

          <div class="select-menu-item js-navigation-item js-this-repository-navigation-item selected">
            <span class="select-menu-item-icon octicon octicon-check"></span>
            <input type="radio" class="js-search-this-repository" name="search_target" value="repository" checked="checked" />
            <div class="select-menu-item-text js-select-button-text">This repository</div>
          </div> <!-- /.select-menu-item -->

          <div class="select-menu-item js-navigation-item js-all-repositories-navigation-item">
            <span class="select-menu-item-icon octicon octicon-check"></span>
            <input type="radio" name="search_target" value="global" />
            <div class="select-menu-item-text js-select-button-text">All repositories</div>
          </div> <!-- /.select-menu-item -->

        </div>
      </div>
    </div>

  <span class="help tooltipped tooltipped-s" aria-label="Show command bar help">
    <span class="octicon octicon-question"></span>
  </span>


  <input type="hidden" name="ref" value="cmdform">

</form>
    </div>

  </div>
</div>



      <div id="start-of-content" class="accessibility-aid"></div>
          <div class="site" itemscope itemtype="http://schema.org/WebPage">
    <div id="js-flash-container">
      
    </div>
    <div class="pagehead repohead instapaper_ignore readability-menu">
      <div class="container">
        

<ul class="pagehead-actions">


  <li>
    <a href="/login?return_to=%2Fjovo%2Foopsi"
    class="minibutton with-count star-button tooltipped tooltipped-n"
    aria-label="You must be signed in to star a repository" rel="nofollow">
    <span class="octicon octicon-star"></span>Star
  </a>

    <a class="social-count js-social-count" href="/jovo/oopsi/stargazers">
      8
    </a>

  </li>

    <li>
      <a href="/login?return_to=%2Fjovo%2Foopsi"
        class="minibutton with-count js-toggler-target fork-button tooltipped tooltipped-n"
        aria-label="You must be signed in to fork a repository" rel="nofollow">
        <span class="octicon octicon-repo-forked"></span>Fork
      </a>
      <a href="/jovo/oopsi/network" class="social-count">
        3
      </a>
    </li>
</ul>

        <h1 itemscope itemtype="http://data-vocabulary.org/Breadcrumb" class="entry-title public">
          <span class="repo-label"><span>public</span></span>
          <span class="mega-octicon octicon-repo"></span>
          <span class="author"><a href="/jovo" class="url fn" itemprop="url" rel="author"><span itemprop="title">jovo</span></a></span><!--
       --><span class="path-divider">/</span><!--
       --><strong><a href="/jovo/oopsi" class="js-current-repository js-repo-home-link">oopsi</a></strong>

          <span class="page-context-loader">
            <img alt="" height="16" src="https://assets-cdn.github.com/images/spinners/octocat-spinner-32.gif" width="16" />
          </span>

        </h1>
      </div><!-- /.container -->
    </div><!-- /.repohead -->

    <div class="container">
      <div class="repository-with-sidebar repo-container new-discussion-timeline js-new-discussion-timeline  ">
        <div class="repository-sidebar clearfix">
            

<div class="sunken-menu vertical-right repo-nav js-repo-nav js-repository-container-pjax js-octicon-loaders">
  <div class="sunken-menu-contents">
    <ul class="sunken-menu-group">
      <li class="tooltipped tooltipped-w" aria-label="Code">
        <a href="/jovo/oopsi" aria-label="Code" class="selected js-selected-navigation-item sunken-menu-item" data-hotkey="g c" data-pjax="true" data-selected-links="repo_source repo_downloads repo_commits repo_releases repo_tags repo_branches /jovo/oopsi">
          <span class="octicon octicon-code"></span> <span class="full-word">Code</span>
          <img alt="" class="mini-loader" height="16" src="https://assets-cdn.github.com/images/spinners/octocat-spinner-32.gif" width="16" />
</a>      </li>

        <li class="tooltipped tooltipped-w" aria-label="Issues">
          <a href="/jovo/oopsi/issues" aria-label="Issues" class="js-selected-navigation-item sunken-menu-item js-disable-pjax" data-hotkey="g i" data-selected-links="repo_issues /jovo/oopsi/issues">
            <span class="octicon octicon-issue-opened"></span> <span class="full-word">Issues</span>
            <span class='counter'>0</span>
            <img alt="" class="mini-loader" height="16" src="https://assets-cdn.github.com/images/spinners/octocat-spinner-32.gif" width="16" />
</a>        </li>

      <li class="tooltipped tooltipped-w" aria-label="Pull Requests">
        <a href="/jovo/oopsi/pulls" aria-label="Pull Requests" class="js-selected-navigation-item sunken-menu-item js-disable-pjax" data-hotkey="g p" data-selected-links="repo_pulls /jovo/oopsi/pulls">
            <span class="octicon octicon-git-pull-request"></span> <span class="full-word">Pull Requests</span>
            <span class='counter'>0</span>
            <img alt="" class="mini-loader" height="16" src="https://assets-cdn.github.com/images/spinners/octocat-spinner-32.gif" width="16" />
</a>      </li>


        <li class="tooltipped tooltipped-w" aria-label="Wiki">
          <a href="/jovo/oopsi/wiki" aria-label="Wiki" class="js-selected-navigation-item sunken-menu-item js-disable-pjax" data-hotkey="g w" data-selected-links="repo_wiki /jovo/oopsi/wiki">
            <span class="octicon octicon-book"></span> <span class="full-word">Wiki</span>
            <img alt="" class="mini-loader" height="16" src="https://assets-cdn.github.com/images/spinners/octocat-spinner-32.gif" width="16" />
</a>        </li>
    </ul>
    <div class="sunken-menu-separator"></div>
    <ul class="sunken-menu-group">

      <li class="tooltipped tooltipped-w" aria-label="Pulse">
        <a href="/jovo/oopsi/pulse" aria-label="Pulse" class="js-selected-navigation-item sunken-menu-item" data-pjax="true" data-selected-links="pulse /jovo/oopsi/pulse">
          <span class="octicon octicon-pulse"></span> <span class="full-word">Pulse</span>
          <img alt="" class="mini-loader" height="16" src="https://assets-cdn.github.com/images/spinners/octocat-spinner-32.gif" width="16" />
</a>      </li>

      <li class="tooltipped tooltipped-w" aria-label="Graphs">
        <a href="/jovo/oopsi/graphs" aria-label="Graphs" class="js-selected-navigation-item sunken-menu-item" data-pjax="true" data-selected-links="repo_graphs repo_contributors /jovo/oopsi/graphs">
          <span class="octicon octicon-graph"></span> <span class="full-word">Graphs</span>
          <img alt="" class="mini-loader" height="16" src="https://assets-cdn.github.com/images/spinners/octocat-spinner-32.gif" width="16" />
</a>      </li>

      <li class="tooltipped tooltipped-w" aria-label="Network">
        <a href="/jovo/oopsi/network" aria-label="Network" class="js-selected-navigation-item sunken-menu-item js-disable-pjax" data-selected-links="repo_network /jovo/oopsi/network">
          <span class="octicon octicon-repo-forked"></span> <span class="full-word">Network</span>
          <img alt="" class="mini-loader" height="16" src="https://assets-cdn.github.com/images/spinners/octocat-spinner-32.gif" width="16" />
</a>      </li>
    </ul>


  </div>
</div>

              <div class="only-with-full-nav">
                

  

<div class="clone-url open"
  data-protocol-type="http"
  data-url="/users/set_protocol?protocol_selector=http&amp;protocol_type=clone">
  <h3><strong>HTTPS</strong> clone URL</h3>
  <div class="clone-url-box">
    <input type="text" class="clone js-url-field"
           value="https://github.com/jovo/oopsi.git" readonly="readonly">
    <span class="url-box-clippy">
    <button aria-label="copy to clipboard" class="js-zeroclipboard minibutton zeroclipboard-button" data-clipboard-text="https://github.com/jovo/oopsi.git" data-copied-hint="copied!" type="button"><span class="octicon octicon-clippy"></span></button>
    </span>
  </div>
</div>

  

<div class="clone-url "
  data-protocol-type="subversion"
  data-url="/users/set_protocol?protocol_selector=subversion&amp;protocol_type=clone">
  <h3><strong>Subversion</strong> checkout URL</h3>
  <div class="clone-url-box">
    <input type="text" class="clone js-url-field"
           value="https://github.com/jovo/oopsi" readonly="readonly">
    <span class="url-box-clippy">
    <button aria-label="copy to clipboard" class="js-zeroclipboard minibutton zeroclipboard-button" data-clipboard-text="https://github.com/jovo/oopsi" data-copied-hint="copied!" type="button"><span class="octicon octicon-clippy"></span></button>
    </span>
  </div>
</div>


<p class="clone-options">You can clone with
      <a href="#" class="js-clone-selector" data-protocol="http">HTTPS</a>
      or <a href="#" class="js-clone-selector" data-protocol="subversion">Subversion</a>.
  <span class="help tooltipped tooltipped-n" aria-label="Get help on which URL is right for you.">
    <a href="https://help.github.com/articles/which-remote-url-should-i-use">
    <span class="octicon octicon-question"></span>
    </a>
  </span>
</p>


  <a href="http://windows.github.com" class="minibutton sidebar-button" title="Save jovo/oopsi to your computer and use it in GitHub Desktop." aria-label="Save jovo/oopsi to your computer and use it in GitHub Desktop.">
    <span class="octicon octicon-device-desktop"></span>
    Clone in Desktop
  </a>

                <a href="/jovo/oopsi/archive/master.zip"
                   class="minibutton sidebar-button"
                   aria-label="Download jovo/oopsi as a zip file"
                   title="Download jovo/oopsi as a zip file"
                   rel="nofollow">
                  <span class="octicon octicon-cloud-download"></span>
                  Download ZIP
                </a>
              </div>
        </div><!-- /.repository-sidebar -->

        <div id="js-repo-pjax-container" class="repository-content context-loader-container" data-pjax-container>
          


<a href="/jovo/oopsi/blob/d1931c4faf33728e400112c6516770f530418200/fast_oopsi.m" class="hidden js-permalink-shortcut" data-hotkey="y">Permalink</a>

<!-- blob contrib key: blob_contributors:v21:435ae2bf7e8a4ca9dfba874f010887c7 -->

<p title="This is a placeholder element" class="js-history-link-replace hidden"></p>

<a href="/jovo/oopsi/find/master" data-pjax data-hotkey="t" class="js-show-file-finder" style="display:none">Show File Finder</a>

<div class="file-navigation">
  

<div class="select-menu js-menu-container js-select-menu" >
  <span class="minibutton select-menu-button js-menu-target" data-hotkey="w"
    data-master-branch="master"
    data-ref="master"
    role="button" aria-label="Switch branches or tags" tabindex="0" aria-haspopup="true">
    <span class="octicon octicon-git-branch"></span>
    <i>branch:</i>
    <span class="js-select-button">master</span>
  </span>

  <div class="select-menu-modal-holder js-menu-content js-navigation-container" data-pjax aria-hidden="true">

    <div class="select-menu-modal">
      <div class="select-menu-header">
        <span class="select-menu-title">Switch branches/tags</span>
        <span class="octicon octicon-x js-menu-close"></span>
      </div> <!-- /.select-menu-header -->

      <div class="select-menu-filters">
        <div class="select-menu-text-filter">
          <input type="text" aria-label="Filter branches/tags" id="context-commitish-filter-field" class="js-filterable-field js-navigation-enable" placeholder="Filter branches/tags">
        </div>
        <div class="select-menu-tabs">
          <ul>
            <li class="select-menu-tab">
              <a href="#" data-tab-filter="branches" class="js-select-menu-tab">Branches</a>
            </li>
            <li class="select-menu-tab">
              <a href="#" data-tab-filter="tags" class="js-select-menu-tab">Tags</a>
            </li>
          </ul>
        </div><!-- /.select-menu-tabs -->
      </div><!-- /.select-menu-filters -->

      <div class="select-menu-list select-menu-tab-bucket js-select-menu-tab-bucket" data-tab-filter="branches">

        <div data-filterable-for="context-commitish-filter-field" data-filterable-type="substring">


            <div class="select-menu-item js-navigation-item ">
              <span class="select-menu-item-icon octicon octicon-check"></span>
              <a href="/jovo/oopsi/blob/gh-pages/fast_oopsi.m"
                 data-name="gh-pages"
                 data-skip-pjax="true"
                 rel="nofollow"
                 class="js-navigation-open select-menu-item-text js-select-button-text css-truncate-target"
                 title="gh-pages">gh-pages</a>
            </div> <!-- /.select-menu-item -->
            <div class="select-menu-item js-navigation-item selected">
              <span class="select-menu-item-icon octicon octicon-check"></span>
              <a href="/jovo/oopsi/blob/master/fast_oopsi.m"
                 data-name="master"
                 data-skip-pjax="true"
                 rel="nofollow"
                 class="js-navigation-open select-menu-item-text js-select-button-text css-truncate-target"
                 title="master">master</a>
            </div> <!-- /.select-menu-item -->
        </div>

          <div class="select-menu-no-results">Nothing to show</div>
      </div> <!-- /.select-menu-list -->

      <div class="select-menu-list select-menu-tab-bucket js-select-menu-tab-bucket" data-tab-filter="tags">
        <div data-filterable-for="context-commitish-filter-field" data-filterable-type="substring">


            <div class="select-menu-item js-navigation-item ">
              <span class="select-menu-item-icon octicon octicon-check"></span>
              <a href="/jovo/oopsi/tree/v1.0/fast_oopsi.m"
                 data-name="v1.0"
                 data-skip-pjax="true"
                 rel="nofollow"
                 class="js-navigation-open select-menu-item-text js-select-button-text css-truncate-target"
                 title="v1.0">v1.0</a>
            </div> <!-- /.select-menu-item -->
        </div>

        <div class="select-menu-no-results">Nothing to show</div>
      </div> <!-- /.select-menu-list -->

    </div> <!-- /.select-menu-modal -->
  </div> <!-- /.select-menu-modal-holder -->
</div> <!-- /.select-menu -->

  <div class="breadcrumb">
    <span class='repo-root js-repo-root'><span itemscope="" itemtype="http://data-vocabulary.org/Breadcrumb"><a href="/jovo/oopsi" data-branch="master" data-direction="back" data-pjax="true" itemscope="url"><span itemprop="title">oopsi</span></a></span></span><span class="separator"> / </span><strong class="final-path">fast_oopsi.m</strong> <button aria-label="copy to clipboard" class="js-zeroclipboard minibutton zeroclipboard-button" data-clipboard-text="fast_oopsi.m" data-copied-hint="copied!" type="button"><span class="octicon octicon-clippy"></span></button>
  </div>
</div>


  <div class="commit commit-loader file-history-tease js-deferred-content" data-url="/jovo/oopsi/contributors/master/fast_oopsi.m">
    Fetching contributors…

    <div class="participation">
      <p class="loader-loading"><img alt="" height="16" src="https://assets-cdn.github.com/images/spinners/octocat-spinner-32-EAF2F5.gif" width="16" /></p>
      <p class="loader-error">Cannot retrieve contributors at this time</p>
    </div>
  </div>

<div class="file-box">
  <div class="file">
    <div class="meta clearfix">
      <div class="info file-name">
        <span class="icon"><b class="octicon octicon-file-text"></b></span>
        <span class="mode" title="File Mode">executable file</span>
        <span class="meta-divider"></span>
          <span>416 lines (374 sloc)</span>
          <span class="meta-divider"></span>
        <span>18.518 kb</span>
      </div>
      <div class="actions">
        <div class="button-group">
            <a class="minibutton tooltipped tooltipped-w"
               href="http://windows.github.com" aria-label="Open this file in GitHub for Windows">
                <span class="octicon octicon-device-desktop"></span> Open
            </a>
              <a class="minibutton disabled tooltipped tooltipped-w" href="#"
                 aria-label="You must be signed in to make or propose changes">Edit</a>
          <a href="/jovo/oopsi/raw/master/fast_oopsi.m" class="button minibutton " id="raw-url">Raw</a>
            <a href="/jovo/oopsi/blame/master/fast_oopsi.m" class="button minibutton js-update-url-with-hash">Blame</a>
          <a href="/jovo/oopsi/commits/master/fast_oopsi.m" class="button minibutton " rel="nofollow">History</a>
        </div><!-- /.button-group -->
          <a class="minibutton danger disabled empty-icon tooltipped tooltipped-w" href="#"
             aria-label="You must be signed in to make or propose changes">
          Delete
        </a>
      </div><!-- /.actions -->
    </div>
      
  <div class="blob-wrapper data type-matlab js-blob-data">
       <table class="file-code file-diff tab-size-8">
         <tr class="file-code-line">
           <td class="blob-line-nums">
             <span id="L1" rel="#L1">1</span>
<span id="L2" rel="#L2">2</span>
<span id="L3" rel="#L3">3</span>
<span id="L4" rel="#L4">4</span>
<span id="L5" rel="#L5">5</span>
<span id="L6" rel="#L6">6</span>
<span id="L7" rel="#L7">7</span>
<span id="L8" rel="#L8">8</span>
<span id="L9" rel="#L9">9</span>
<span id="L10" rel="#L10">10</span>
<span id="L11" rel="#L11">11</span>
<span id="L12" rel="#L12">12</span>
<span id="L13" rel="#L13">13</span>
<span id="L14" rel="#L14">14</span>
<span id="L15" rel="#L15">15</span>
<span id="L16" rel="#L16">16</span>
<span id="L17" rel="#L17">17</span>
<span id="L18" rel="#L18">18</span>
<span id="L19" rel="#L19">19</span>
<span id="L20" rel="#L20">20</span>
<span id="L21" rel="#L21">21</span>
<span id="L22" rel="#L22">22</span>
<span id="L23" rel="#L23">23</span>
<span id="L24" rel="#L24">24</span>
<span id="L25" rel="#L25">25</span>
<span id="L26" rel="#L26">26</span>
<span id="L27" rel="#L27">27</span>
<span id="L28" rel="#L28">28</span>
<span id="L29" rel="#L29">29</span>
<span id="L30" rel="#L30">30</span>
<span id="L31" rel="#L31">31</span>
<span id="L32" rel="#L32">32</span>
<span id="L33" rel="#L33">33</span>
<span id="L34" rel="#L34">34</span>
<span id="L35" rel="#L35">35</span>
<span id="L36" rel="#L36">36</span>
<span id="L37" rel="#L37">37</span>
<span id="L38" rel="#L38">38</span>
<span id="L39" rel="#L39">39</span>
<span id="L40" rel="#L40">40</span>
<span id="L41" rel="#L41">41</span>
<span id="L42" rel="#L42">42</span>
<span id="L43" rel="#L43">43</span>
<span id="L44" rel="#L44">44</span>
<span id="L45" rel="#L45">45</span>
<span id="L46" rel="#L46">46</span>
<span id="L47" rel="#L47">47</span>
<span id="L48" rel="#L48">48</span>
<span id="L49" rel="#L49">49</span>
<span id="L50" rel="#L50">50</span>
<span id="L51" rel="#L51">51</span>
<span id="L52" rel="#L52">52</span>
<span id="L53" rel="#L53">53</span>
<span id="L54" rel="#L54">54</span>
<span id="L55" rel="#L55">55</span>
<span id="L56" rel="#L56">56</span>
<span id="L57" rel="#L57">57</span>
<span id="L58" rel="#L58">58</span>
<span id="L59" rel="#L59">59</span>
<span id="L60" rel="#L60">60</span>
<span id="L61" rel="#L61">61</span>
<span id="L62" rel="#L62">62</span>
<span id="L63" rel="#L63">63</span>
<span id="L64" rel="#L64">64</span>
<span id="L65" rel="#L65">65</span>
<span id="L66" rel="#L66">66</span>
<span id="L67" rel="#L67">67</span>
<span id="L68" rel="#L68">68</span>
<span id="L69" rel="#L69">69</span>
<span id="L70" rel="#L70">70</span>
<span id="L71" rel="#L71">71</span>
<span id="L72" rel="#L72">72</span>
<span id="L73" rel="#L73">73</span>
<span id="L74" rel="#L74">74</span>
<span id="L75" rel="#L75">75</span>
<span id="L76" rel="#L76">76</span>
<span id="L77" rel="#L77">77</span>
<span id="L78" rel="#L78">78</span>
<span id="L79" rel="#L79">79</span>
<span id="L80" rel="#L80">80</span>
<span id="L81" rel="#L81">81</span>
<span id="L82" rel="#L82">82</span>
<span id="L83" rel="#L83">83</span>
<span id="L84" rel="#L84">84</span>
<span id="L85" rel="#L85">85</span>
<span id="L86" rel="#L86">86</span>
<span id="L87" rel="#L87">87</span>
<span id="L88" rel="#L88">88</span>
<span id="L89" rel="#L89">89</span>
<span id="L90" rel="#L90">90</span>
<span id="L91" rel="#L91">91</span>
<span id="L92" rel="#L92">92</span>
<span id="L93" rel="#L93">93</span>
<span id="L94" rel="#L94">94</span>
<span id="L95" rel="#L95">95</span>
<span id="L96" rel="#L96">96</span>
<span id="L97" rel="#L97">97</span>
<span id="L98" rel="#L98">98</span>
<span id="L99" rel="#L99">99</span>
<span id="L100" rel="#L100">100</span>
<span id="L101" rel="#L101">101</span>
<span id="L102" rel="#L102">102</span>
<span id="L103" rel="#L103">103</span>
<span id="L104" rel="#L104">104</span>
<span id="L105" rel="#L105">105</span>
<span id="L106" rel="#L106">106</span>
<span id="L107" rel="#L107">107</span>
<span id="L108" rel="#L108">108</span>
<span id="L109" rel="#L109">109</span>
<span id="L110" rel="#L110">110</span>
<span id="L111" rel="#L111">111</span>
<span id="L112" rel="#L112">112</span>
<span id="L113" rel="#L113">113</span>
<span id="L114" rel="#L114">114</span>
<span id="L115" rel="#L115">115</span>
<span id="L116" rel="#L116">116</span>
<span id="L117" rel="#L117">117</span>
<span id="L118" rel="#L118">118</span>
<span id="L119" rel="#L119">119</span>
<span id="L120" rel="#L120">120</span>
<span id="L121" rel="#L121">121</span>
<span id="L122" rel="#L122">122</span>
<span id="L123" rel="#L123">123</span>
<span id="L124" rel="#L124">124</span>
<span id="L125" rel="#L125">125</span>
<span id="L126" rel="#L126">126</span>
<span id="L127" rel="#L127">127</span>
<span id="L128" rel="#L128">128</span>
<span id="L129" rel="#L129">129</span>
<span id="L130" rel="#L130">130</span>
<span id="L131" rel="#L131">131</span>
<span id="L132" rel="#L132">132</span>
<span id="L133" rel="#L133">133</span>
<span id="L134" rel="#L134">134</span>
<span id="L135" rel="#L135">135</span>
<span id="L136" rel="#L136">136</span>
<span id="L137" rel="#L137">137</span>
<span id="L138" rel="#L138">138</span>
<span id="L139" rel="#L139">139</span>
<span id="L140" rel="#L140">140</span>
<span id="L141" rel="#L141">141</span>
<span id="L142" rel="#L142">142</span>
<span id="L143" rel="#L143">143</span>
<span id="L144" rel="#L144">144</span>
<span id="L145" rel="#L145">145</span>
<span id="L146" rel="#L146">146</span>
<span id="L147" rel="#L147">147</span>
<span id="L148" rel="#L148">148</span>
<span id="L149" rel="#L149">149</span>
<span id="L150" rel="#L150">150</span>
<span id="L151" rel="#L151">151</span>
<span id="L152" rel="#L152">152</span>
<span id="L153" rel="#L153">153</span>
<span id="L154" rel="#L154">154</span>
<span id="L155" rel="#L155">155</span>
<span id="L156" rel="#L156">156</span>
<span id="L157" rel="#L157">157</span>
<span id="L158" rel="#L158">158</span>
<span id="L159" rel="#L159">159</span>
<span id="L160" rel="#L160">160</span>
<span id="L161" rel="#L161">161</span>
<span id="L162" rel="#L162">162</span>
<span id="L163" rel="#L163">163</span>
<span id="L164" rel="#L164">164</span>
<span id="L165" rel="#L165">165</span>
<span id="L166" rel="#L166">166</span>
<span id="L167" rel="#L167">167</span>
<span id="L168" rel="#L168">168</span>
<span id="L169" rel="#L169">169</span>
<span id="L170" rel="#L170">170</span>
<span id="L171" rel="#L171">171</span>
<span id="L172" rel="#L172">172</span>
<span id="L173" rel="#L173">173</span>
<span id="L174" rel="#L174">174</span>
<span id="L175" rel="#L175">175</span>
<span id="L176" rel="#L176">176</span>
<span id="L177" rel="#L177">177</span>
<span id="L178" rel="#L178">178</span>
<span id="L179" rel="#L179">179</span>
<span id="L180" rel="#L180">180</span>
<span id="L181" rel="#L181">181</span>
<span id="L182" rel="#L182">182</span>
<span id="L183" rel="#L183">183</span>
<span id="L184" rel="#L184">184</span>
<span id="L185" rel="#L185">185</span>
<span id="L186" rel="#L186">186</span>
<span id="L187" rel="#L187">187</span>
<span id="L188" rel="#L188">188</span>
<span id="L189" rel="#L189">189</span>
<span id="L190" rel="#L190">190</span>
<span id="L191" rel="#L191">191</span>
<span id="L192" rel="#L192">192</span>
<span id="L193" rel="#L193">193</span>
<span id="L194" rel="#L194">194</span>
<span id="L195" rel="#L195">195</span>
<span id="L196" rel="#L196">196</span>
<span id="L197" rel="#L197">197</span>
<span id="L198" rel="#L198">198</span>
<span id="L199" rel="#L199">199</span>
<span id="L200" rel="#L200">200</span>
<span id="L201" rel="#L201">201</span>
<span id="L202" rel="#L202">202</span>
<span id="L203" rel="#L203">203</span>
<span id="L204" rel="#L204">204</span>
<span id="L205" rel="#L205">205</span>
<span id="L206" rel="#L206">206</span>
<span id="L207" rel="#L207">207</span>
<span id="L208" rel="#L208">208</span>
<span id="L209" rel="#L209">209</span>
<span id="L210" rel="#L210">210</span>
<span id="L211" rel="#L211">211</span>
<span id="L212" rel="#L212">212</span>
<span id="L213" rel="#L213">213</span>
<span id="L214" rel="#L214">214</span>
<span id="L215" rel="#L215">215</span>
<span id="L216" rel="#L216">216</span>
<span id="L217" rel="#L217">217</span>
<span id="L218" rel="#L218">218</span>
<span id="L219" rel="#L219">219</span>
<span id="L220" rel="#L220">220</span>
<span id="L221" rel="#L221">221</span>
<span id="L222" rel="#L222">222</span>
<span id="L223" rel="#L223">223</span>
<span id="L224" rel="#L224">224</span>
<span id="L225" rel="#L225">225</span>
<span id="L226" rel="#L226">226</span>
<span id="L227" rel="#L227">227</span>
<span id="L228" rel="#L228">228</span>
<span id="L229" rel="#L229">229</span>
<span id="L230" rel="#L230">230</span>
<span id="L231" rel="#L231">231</span>
<span id="L232" rel="#L232">232</span>
<span id="L233" rel="#L233">233</span>
<span id="L234" rel="#L234">234</span>
<span id="L235" rel="#L235">235</span>
<span id="L236" rel="#L236">236</span>
<span id="L237" rel="#L237">237</span>
<span id="L238" rel="#L238">238</span>
<span id="L239" rel="#L239">239</span>
<span id="L240" rel="#L240">240</span>
<span id="L241" rel="#L241">241</span>
<span id="L242" rel="#L242">242</span>
<span id="L243" rel="#L243">243</span>
<span id="L244" rel="#L244">244</span>
<span id="L245" rel="#L245">245</span>
<span id="L246" rel="#L246">246</span>
<span id="L247" rel="#L247">247</span>
<span id="L248" rel="#L248">248</span>
<span id="L249" rel="#L249">249</span>
<span id="L250" rel="#L250">250</span>
<span id="L251" rel="#L251">251</span>
<span id="L252" rel="#L252">252</span>
<span id="L253" rel="#L253">253</span>
<span id="L254" rel="#L254">254</span>
<span id="L255" rel="#L255">255</span>
<span id="L256" rel="#L256">256</span>
<span id="L257" rel="#L257">257</span>
<span id="L258" rel="#L258">258</span>
<span id="L259" rel="#L259">259</span>
<span id="L260" rel="#L260">260</span>
<span id="L261" rel="#L261">261</span>
<span id="L262" rel="#L262">262</span>
<span id="L263" rel="#L263">263</span>
<span id="L264" rel="#L264">264</span>
<span id="L265" rel="#L265">265</span>
<span id="L266" rel="#L266">266</span>
<span id="L267" rel="#L267">267</span>
<span id="L268" rel="#L268">268</span>
<span id="L269" rel="#L269">269</span>
<span id="L270" rel="#L270">270</span>
<span id="L271" rel="#L271">271</span>
<span id="L272" rel="#L272">272</span>
<span id="L273" rel="#L273">273</span>
<span id="L274" rel="#L274">274</span>
<span id="L275" rel="#L275">275</span>
<span id="L276" rel="#L276">276</span>
<span id="L277" rel="#L277">277</span>
<span id="L278" rel="#L278">278</span>
<span id="L279" rel="#L279">279</span>
<span id="L280" rel="#L280">280</span>
<span id="L281" rel="#L281">281</span>
<span id="L282" rel="#L282">282</span>
<span id="L283" rel="#L283">283</span>
<span id="L284" rel="#L284">284</span>
<span id="L285" rel="#L285">285</span>
<span id="L286" rel="#L286">286</span>
<span id="L287" rel="#L287">287</span>
<span id="L288" rel="#L288">288</span>
<span id="L289" rel="#L289">289</span>
<span id="L290" rel="#L290">290</span>
<span id="L291" rel="#L291">291</span>
<span id="L292" rel="#L292">292</span>
<span id="L293" rel="#L293">293</span>
<span id="L294" rel="#L294">294</span>
<span id="L295" rel="#L295">295</span>
<span id="L296" rel="#L296">296</span>
<span id="L297" rel="#L297">297</span>
<span id="L298" rel="#L298">298</span>
<span id="L299" rel="#L299">299</span>
<span id="L300" rel="#L300">300</span>
<span id="L301" rel="#L301">301</span>
<span id="L302" rel="#L302">302</span>
<span id="L303" rel="#L303">303</span>
<span id="L304" rel="#L304">304</span>
<span id="L305" rel="#L305">305</span>
<span id="L306" rel="#L306">306</span>
<span id="L307" rel="#L307">307</span>
<span id="L308" rel="#L308">308</span>
<span id="L309" rel="#L309">309</span>
<span id="L310" rel="#L310">310</span>
<span id="L311" rel="#L311">311</span>
<span id="L312" rel="#L312">312</span>
<span id="L313" rel="#L313">313</span>
<span id="L314" rel="#L314">314</span>
<span id="L315" rel="#L315">315</span>
<span id="L316" rel="#L316">316</span>
<span id="L317" rel="#L317">317</span>
<span id="L318" rel="#L318">318</span>
<span id="L319" rel="#L319">319</span>
<span id="L320" rel="#L320">320</span>
<span id="L321" rel="#L321">321</span>
<span id="L322" rel="#L322">322</span>
<span id="L323" rel="#L323">323</span>
<span id="L324" rel="#L324">324</span>
<span id="L325" rel="#L325">325</span>
<span id="L326" rel="#L326">326</span>
<span id="L327" rel="#L327">327</span>
<span id="L328" rel="#L328">328</span>
<span id="L329" rel="#L329">329</span>
<span id="L330" rel="#L330">330</span>
<span id="L331" rel="#L331">331</span>
<span id="L332" rel="#L332">332</span>
<span id="L333" rel="#L333">333</span>
<span id="L334" rel="#L334">334</span>
<span id="L335" rel="#L335">335</span>
<span id="L336" rel="#L336">336</span>
<span id="L337" rel="#L337">337</span>
<span id="L338" rel="#L338">338</span>
<span id="L339" rel="#L339">339</span>
<span id="L340" rel="#L340">340</span>
<span id="L341" rel="#L341">341</span>
<span id="L342" rel="#L342">342</span>
<span id="L343" rel="#L343">343</span>
<span id="L344" rel="#L344">344</span>
<span id="L345" rel="#L345">345</span>
<span id="L346" rel="#L346">346</span>
<span id="L347" rel="#L347">347</span>
<span id="L348" rel="#L348">348</span>
<span id="L349" rel="#L349">349</span>
<span id="L350" rel="#L350">350</span>
<span id="L351" rel="#L351">351</span>
<span id="L352" rel="#L352">352</span>
<span id="L353" rel="#L353">353</span>
<span id="L354" rel="#L354">354</span>
<span id="L355" rel="#L355">355</span>
<span id="L356" rel="#L356">356</span>
<span id="L357" rel="#L357">357</span>
<span id="L358" rel="#L358">358</span>
<span id="L359" rel="#L359">359</span>
<span id="L360" rel="#L360">360</span>
<span id="L361" rel="#L361">361</span>
<span id="L362" rel="#L362">362</span>
<span id="L363" rel="#L363">363</span>
<span id="L364" rel="#L364">364</span>
<span id="L365" rel="#L365">365</span>
<span id="L366" rel="#L366">366</span>
<span id="L367" rel="#L367">367</span>
<span id="L368" rel="#L368">368</span>
<span id="L369" rel="#L369">369</span>
<span id="L370" rel="#L370">370</span>
<span id="L371" rel="#L371">371</span>
<span id="L372" rel="#L372">372</span>
<span id="L373" rel="#L373">373</span>
<span id="L374" rel="#L374">374</span>
<span id="L375" rel="#L375">375</span>
<span id="L376" rel="#L376">376</span>
<span id="L377" rel="#L377">377</span>
<span id="L378" rel="#L378">378</span>
<span id="L379" rel="#L379">379</span>
<span id="L380" rel="#L380">380</span>
<span id="L381" rel="#L381">381</span>
<span id="L382" rel="#L382">382</span>
<span id="L383" rel="#L383">383</span>
<span id="L384" rel="#L384">384</span>
<span id="L385" rel="#L385">385</span>
<span id="L386" rel="#L386">386</span>
<span id="L387" rel="#L387">387</span>
<span id="L388" rel="#L388">388</span>
<span id="L389" rel="#L389">389</span>
<span id="L390" rel="#L390">390</span>
<span id="L391" rel="#L391">391</span>
<span id="L392" rel="#L392">392</span>
<span id="L393" rel="#L393">393</span>
<span id="L394" rel="#L394">394</span>
<span id="L395" rel="#L395">395</span>
<span id="L396" rel="#L396">396</span>
<span id="L397" rel="#L397">397</span>
<span id="L398" rel="#L398">398</span>
<span id="L399" rel="#L399">399</span>
<span id="L400" rel="#L400">400</span>
<span id="L401" rel="#L401">401</span>
<span id="L402" rel="#L402">402</span>
<span id="L403" rel="#L403">403</span>
<span id="L404" rel="#L404">404</span>
<span id="L405" rel="#L405">405</span>
<span id="L406" rel="#L406">406</span>
<span id="L407" rel="#L407">407</span>
<span id="L408" rel="#L408">408</span>
<span id="L409" rel="#L409">409</span>
<span id="L410" rel="#L410">410</span>
<span id="L411" rel="#L411">411</span>
<span id="L412" rel="#L412">412</span>
<span id="L413" rel="#L413">413</span>
<span id="L414" rel="#L414">414</span>
<span id="L415" rel="#L415">415</span>
<span id="L416" rel="#L416">416</span>

           </td>
           <td class="blob-line-code"><div class="code-body highlight"><pre><div class='line' id='LC1'><span class="k">function</span><span class="w"> </span>[n_best P_best V C]<span class="p">=</span><span class="nf">fast_oopsi</span><span class="p">(</span>F,V,P<span class="p">)</span><span class="w"></span></div><div class='line' id='LC2'><span class="c">% this function solves the following optimization problem:</span></div><div class='line' id='LC3'><span class="c">% (*) n_best = argmax_{n &gt;= 0} P(n | F)</span></div><div class='line' id='LC4'><span class="c">% which is a MAP estimate for the most likely spike train given the</span></div><div class='line' id='LC5'><span class="c">% fluorescence signal.  given the model:</span></div><div class='line' id='LC6'><span class="c">%</span></div><div class='line' id='LC7'><span class="c">% &lt;latex&gt;</span></div><div class='line' id='LC8'><span class="c">% \begin{align}</span></div><div class='line' id='LC9'><span class="c">% C_t &amp;= \gamma*C_{t-1} + n_t, \qquad &amp; n_t &amp; \sim \text{Poisson}(n_t; \lamda_t \Delta)</span></div><div class='line' id='LC10'><span class="c">% F_t &amp;= \alpha(C_t + \beta) + \sigma \varepsilon_t, &amp;\varepsilon_t &amp;\sim \mathcal{N}(0,1)</span></div><div class='line' id='LC11'><span class="c">% \end{align}</span></div><div class='line' id='LC12'><span class="c">% &lt;/latex&gt;</span></div><div class='line' id='LC13'><span class="c">%</span></div><div class='line' id='LC14'><span class="c">% if F_t is a vector, then &#39;a&#39; is a vector as well</span></div><div class='line' id='LC15'><span class="c">% we approx the Poisson with an Exponential (which means we don&#39;t require integer numbers of spikes).</span></div><div class='line' id='LC16'><span class="c">% we take an &quot;interior-point&quot; approach to impose the nonnegative contraint on (*).</span></div><div class='line' id='LC17'><span class="c">% each step is solved in O(T)</span></div><div class='line' id='LC18'><span class="c">% time by utilizing gaussian elimination on the tridiagonal hessian, as</span></div><div class='line' id='LC19'><span class="c">% opposed to the O(T^3) time typically required for non-negative</span></div><div class='line' id='LC20'><span class="c">% deconvolution.</span></div><div class='line' id='LC21'><span class="c">%</span></div><div class='line' id='LC22'><span class="c">% Input---- only F is REQUIRED.  the others are optional</span></div><div class='line' id='LC23'><span class="c">% F:        fluorescence time series (can be a vector (1 x T) or a matrix (Np x T)</span></div><div class='line' id='LC24'><span class="c">%</span></div><div class='line' id='LC25'><span class="c">% V.        structure of algorithm Variables</span></div><div class='line' id='LC26'><span class="c">%   Ncells: # of cells within ROI</span></div><div class='line' id='LC27'><span class="c">%   T:      # of time steps</span></div><div class='line' id='LC28'><span class="c">%   Npixels:# of pixels in ROI</span></div><div class='line' id='LC29'><span class="c">%   dt:     time step size, ie, frame duration, ie, 1/(imaging rate)</span></div><div class='line' id='LC30'><span class="c">%   n:      if true spike train is known, and we are plotting, plot it (only required is est_a==1)</span></div><div class='line' id='LC31'><span class="c">%   h:      height of ROI (assumes square ROI) (# of pixels) (only required if est_a==1 and we are plotting)</span></div><div class='line' id='LC32'><span class="c">%   w:      width of ROI (assumes square ROI) (# of pixels) (only required if est_a==1 and we are plotting)</span></div><div class='line' id='LC33'><span class="c">%</span></div><div class='line' id='LC34'><span class="c">%   THE FOLLOWING FIELDS CORRESPOND TO CHOICES THAT THE USER MAKE</span></div><div class='line' id='LC35'><span class="c">%</span></div><div class='line' id='LC36'><span class="c">%   fast_poiss:     1 if F_t ~ Poisson, 0 if F_t ~ Gaussian</span></div><div class='line' id='LC37'><span class="c">%   fast_nonlin:    1 if F_t is a nonlinear f(C_t), and 0 if F_t is a linear f(C_t)</span></div><div class='line' id='LC38'><span class="c">%   fast_plot:      1 to plot results after each pseudo-EM iteration, 0 otherwise</span></div><div class='line' id='LC39'><span class="c">%   fast_thr:       1 if thresholding inferred spike train before estiamting {a,b}</span></div><div class='line' id='LC40'><span class="c">%   fast_iter_max:  max # of iterations of pseudo-EM  (1 to use default initial parameters)</span></div><div class='line' id='LC41'><span class="c">%   fast_ignore_post: 1 to keep iterating pseudo-EM even if posterior is not increasing, 0 otherwise</span></div><div class='line' id='LC42'><span class="c">%</span></div><div class='line' id='LC43'><span class="c">%   THE BELOW FIELDS INDICATE WHETHER ONE WANTS TO ESTIMATE EACH OF THE</span></div><div class='line' id='LC44'><span class="c">%   PARAMETERS. IF ANY IS SET TO ZERO, THEN WE DO NOT TRY TO UPDATE THE</span></div><div class='line' id='LC45'><span class="c">%   ORIGINAL ESTIMATE, GIVEN EITHER BY THE USER, OR THE INITIAL ESTIMATE</span></div><div class='line' id='LC46'><span class="c">%   FROM THE CODE</span></div><div class='line' id='LC47'><span class="c">%</span></div><div class='line' id='LC48'><span class="c">%   est_sig:    1 to estimate sig</span></div><div class='line' id='LC49'><span class="c">%   est_lam:    1 to estimate lam</span></div><div class='line' id='LC50'><span class="c">%   est_gam:    1 to estimate gam</span></div><div class='line' id='LC51'><span class="c">%   est_b:      1 to estimate b</span></div><div class='line' id='LC52'><span class="c">%   est_a:      1 to estimate a</span></div><div class='line' id='LC53'><span class="c">%</span></div><div class='line' id='LC54'><span class="c">% P.        structure of neuron model Parameters</span></div><div class='line' id='LC55'><span class="c">%</span></div><div class='line' id='LC56'><span class="c">%   a:      spatial filter</span></div><div class='line' id='LC57'><span class="c">%   b:      background fluorescence</span></div><div class='line' id='LC58'><span class="c">%   sig:    standard deviation of observation noise</span></div><div class='line' id='LC59'><span class="c">%   gam:    decayish, ie, tau=dt/(1-gam)</span></div><div class='line' id='LC60'><span class="c">%   lam:    firing rate-ish, ie, expected # of spikes per frame</span></div><div class='line' id='LC61'><span class="c">%</span></div><div class='line' id='LC62'><span class="c">% Output---</span></div><div class='line' id='LC63'><span class="c">% n_best:   inferred spike train</span></div><div class='line' id='LC64'><span class="c">% P_best:   inferred parameter structure</span></div><div class='line' id='LC65'><span class="c">% V:        structure of Variables for algorithm to run</span></div><div class='line' id='LC66'><br/></div><div class='line' id='LC67'><span class="c">%% initialize algorithm Variables</span></div><div class='line' id='LC68'><span class="n">starttime</span>   <span class="p">=</span> <span class="n">cputime</span><span class="p">;</span></div><div class='line' id='LC69'><span class="n">siz</span>         <span class="p">=</span> <span class="nb">size</span><span class="p">(</span><span class="n">F</span><span class="p">);</span>      <span class="k">if</span> <span class="n">siz</span><span class="p">(</span><span class="mi">2</span><span class="p">)</span><span class="o">==</span><span class="mi">1</span><span class="p">,</span> <span class="n">F</span><span class="p">=</span><span class="n">F</span><span class="o">&#39;</span><span class="p">;</span> <span class="n">siz</span><span class="p">=</span><span class="nb">size</span><span class="p">(</span><span class="n">F</span><span class="p">);</span> <span class="k">end</span></div><div class='line' id='LC70'><span class="nb">j</span><span class="p">=</span><span class="mi">0</span><span class="p">;</span></div><div class='line' id='LC71'><span class="c">% variables determined by the data</span></div><div class='line' id='LC72'><span class="k">if</span> <span class="n">nargin</span> <span class="o">&lt;</span> <span class="mi">2</span><span class="p">,</span>              <span class="n">V</span>   <span class="p">=</span> <span class="n">struct</span><span class="p">;</span>       <span class="k">end</span></div><div class='line' id='LC73'><span class="k">if</span> <span class="o">~</span><span class="n">isfield</span><span class="p">(</span><span class="n">V</span><span class="p">,</span><span class="s">&#39;Ncells&#39;</span><span class="p">),</span>    <span class="n">V</span><span class="p">.</span><span class="n">Ncells</span> <span class="p">=</span> <span class="mi">1</span><span class="p">;</span>       <span class="k">end</span>     <span class="c">% # of cells in image</span></div><div class='line' id='LC74'><span class="k">if</span> <span class="o">~</span><span class="n">isfield</span><span class="p">(</span><span class="n">V</span><span class="p">,</span><span class="s">&#39;T&#39;</span><span class="p">),</span>         <span class="n">V</span><span class="p">.</span><span class="n">T</span> <span class="p">=</span> <span class="n">siz</span><span class="p">(</span><span class="mi">2</span><span class="p">);</span>       <span class="k">end</span>     <span class="c">% # of time steps</span></div><div class='line' id='LC75'><span class="k">if</span> <span class="o">~</span><span class="n">isfield</span><span class="p">(</span><span class="n">V</span><span class="p">,</span><span class="s">&#39;Npixels&#39;</span><span class="p">),</span>   <span class="n">V</span><span class="p">.</span><span class="n">Npixels</span> <span class="p">=</span> <span class="n">siz</span><span class="p">(</span><span class="mi">1</span><span class="p">);</span> <span class="k">end</span>     <span class="c">% # of pixels in ROI</span></div><div class='line' id='LC76'><span class="k">if</span> <span class="o">~</span><span class="n">isfield</span><span class="p">(</span><span class="n">V</span><span class="p">,</span><span class="s">&#39;dt&#39;</span><span class="p">),</span>                                    <span class="c">% frame duration</span></div><div class='line' id='LC77'>&nbsp;&nbsp;&nbsp;&nbsp;<span class="n">fr</span> <span class="p">=</span> <span class="n">input</span><span class="p">(</span><span class="s">&#39;\nwhat was the frame rate for this movie (in Hz)?: &#39;</span><span class="p">);</span></div><div class='line' id='LC78'>&nbsp;&nbsp;&nbsp;&nbsp;<span class="n">V</span><span class="p">.</span><span class="n">dt</span> <span class="p">=</span> <span class="mi">1</span><span class="o">/</span><span class="n">fr</span><span class="p">;</span></div><div class='line' id='LC79'><span class="k">end</span></div><div class='line' id='LC80'><br/></div><div class='line' id='LC81'><span class="c">% variables determined by the user</span></div><div class='line' id='LC82'><span class="k">if</span> <span class="o">~</span><span class="n">isfield</span><span class="p">(</span><span class="n">V</span><span class="p">,</span><span class="s">&#39;fast_poiss&#39;</span><span class="p">),</span><span class="n">V</span><span class="p">.</span><span class="n">fast_poiss</span> <span class="p">=</span> <span class="mi">0</span><span class="p">;</span>   <span class="k">end</span>     <span class="c">% whether observations are Poisson</span></div><div class='line' id='LC83'><span class="k">if</span> <span class="o">~</span><span class="n">isfield</span><span class="p">(</span><span class="n">V</span><span class="p">,</span><span class="s">&#39;fast_nonlin&#39;</span><span class="p">),</span>   <span class="n">V</span><span class="p">.</span><span class="n">fast_nonlin</span>   <span class="p">=</span> <span class="mi">0</span><span class="p">;</span> <span class="k">end</span></div><div class='line' id='LC84'><span class="k">if</span> <span class="n">V</span><span class="p">.</span><span class="n">fast_poiss</span> <span class="o">&amp;&amp;</span> <span class="n">V</span><span class="p">.</span><span class="n">fast_nonlin</span><span class="p">,</span></div><div class='line' id='LC85'>&nbsp;&nbsp;&nbsp;&nbsp;<span class="n">reply</span> <span class="p">=</span> <span class="n">input</span><span class="p">(</span><span class="s">&#39;\ncan be nonlinear observations and poisson, \ntype 1 for nonlin, 2 for poisson, anything else for neither: &#39;</span><span class="p">);</span></div><div class='line' id='LC86'>&nbsp;&nbsp;&nbsp;&nbsp;<span class="k">if</span> <span class="n">reply</span><span class="o">==</span><span class="mi">1</span><span class="p">,</span>        <span class="n">V</span><span class="p">.</span><span class="n">fast_poiss</span> <span class="p">=</span> <span class="mi">0</span><span class="p">;</span>   <span class="n">V</span><span class="p">.</span><span class="n">fast_nonlin</span> <span class="p">=</span> <span class="mi">1</span><span class="p">;</span></div><div class='line' id='LC87'>&nbsp;&nbsp;&nbsp;&nbsp;<span class="k">elseif</span> <span class="n">reply</span><span class="o">==</span><span class="mi">2</span><span class="p">,</span>    <span class="n">V</span><span class="p">.</span><span class="n">fast_poiss</span> <span class="p">=</span> <span class="mi">1</span><span class="p">;</span>   <span class="n">V</span><span class="p">.</span><span class="n">fast_nonlin</span> <span class="p">=</span> <span class="mi">0</span><span class="p">;</span></div><div class='line' id='LC88'>&nbsp;&nbsp;&nbsp;&nbsp;<span class="k">else</span>                <span class="n">V</span><span class="p">.</span><span class="n">fast_poiss</span> <span class="p">=</span> <span class="mi">0</span><span class="p">;</span>   <span class="n">V</span><span class="p">.</span><span class="n">fast_nonlin</span> <span class="p">=</span> <span class="mi">0</span><span class="p">;</span></div><div class='line' id='LC89'>&nbsp;&nbsp;&nbsp;&nbsp;<span class="k">end</span></div><div class='line' id='LC90'><span class="k">end</span></div><div class='line' id='LC91'><span class="k">if</span> <span class="o">~</span><span class="n">isfield</span><span class="p">(</span><span class="n">V</span><span class="p">,</span><span class="s">&#39;fast_iter_max&#39;</span><span class="p">),</span> <span class="n">V</span><span class="p">.</span><span class="n">fast_iter_max</span><span class="p">=</span><span class="mi">1</span><span class="p">;</span> <span class="k">end</span> <span class="c">% max # of iterations before convergence</span></div><div class='line' id='LC92'><br/></div><div class='line' id='LC93'><span class="c">% things that matter if we are iterating to estimate parameters</span></div><div class='line' id='LC94'><span class="k">if</span> <span class="n">V</span><span class="p">.</span><span class="n">fast_iter_max</span><span class="o">&gt;</span><span class="mi">1</span><span class="p">;</span></div><div class='line' id='LC95'>&nbsp;&nbsp;&nbsp;&nbsp;<span class="k">if</span> <span class="n">V</span><span class="p">.</span><span class="n">fast_poiss</span> <span class="o">||</span> <span class="n">V</span><span class="p">.</span><span class="n">fast_nonlin</span><span class="p">,</span></div><div class='line' id='LC96'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span class="nb">disp</span><span class="p">(</span><span class="s">&#39;\ncode does not currrently support estimating parameters for \npoisson or nonlinear observations&#39;</span><span class="p">);</span></div><div class='line' id='LC97'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span class="n">V</span><span class="p">.</span><span class="n">fast_iter_max</span><span class="p">=</span><span class="mi">1</span><span class="p">;</span></div><div class='line' id='LC98'>&nbsp;&nbsp;&nbsp;&nbsp;<span class="k">end</span></div><div class='line' id='LC99'>&nbsp;&nbsp;&nbsp;&nbsp;</div><div class='line' id='LC100'>&nbsp;&nbsp;&nbsp;&nbsp;<span class="k">if</span> <span class="o">~</span><span class="n">isfield</span><span class="p">(</span><span class="n">V</span><span class="p">,</span><span class="s">&#39;fast_plot&#39;</span><span class="p">),</span> <span class="n">V</span><span class="p">.</span><span class="n">fast_plot</span> <span class="p">=</span> <span class="mi">0</span><span class="p">;</span> <span class="k">end</span></div><div class='line' id='LC101'>&nbsp;&nbsp;&nbsp;&nbsp;<span class="k">if</span> <span class="n">V</span><span class="p">.</span><span class="n">fast_plot</span><span class="o">==</span><span class="mi">1</span></div><div class='line' id='LC102'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span class="n">FigNum</span> <span class="p">=</span> <span class="mi">400</span><span class="p">;</span></div><div class='line' id='LC103'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span class="k">if</span> <span class="n">V</span><span class="p">.</span><span class="n">Npixels</span><span class="o">&gt;</span><span class="mi">1</span><span class="p">,</span> <span class="n">figure</span><span class="p">(</span><span class="n">FigNum</span><span class="p">),</span> <span class="n">clf</span><span class="p">,</span> <span class="k">end</span>        <span class="c">% figure showing estimated spatial filter</span></div><div class='line' id='LC104'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span class="n">figure</span><span class="p">(</span><span class="n">FigNum</span><span class="o">+</span><span class="mi">1</span><span class="p">),</span> <span class="n">clf</span>                           <span class="c">% figure showing estimated spike trains</span></div><div class='line' id='LC105'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span class="k">if</span> <span class="n">isfield</span><span class="p">(</span><span class="n">V</span><span class="p">,</span><span class="s">&#39;n&#39;</span><span class="p">),</span> <span class="n">siz</span><span class="p">=</span><span class="nb">size</span><span class="p">(</span><span class="n">V</span><span class="p">.</span><span class="n">n</span><span class="p">);</span> <span class="n">V</span><span class="p">.</span><span class="n">n</span><span class="p">(</span><span class="n">V</span><span class="p">.</span><span class="n">n</span><span class="o">==</span><span class="mi">0</span><span class="p">)=</span><span class="n">NaN</span><span class="p">;</span> <span class="k">if</span> <span class="n">siz</span><span class="p">(</span><span class="mi">1</span><span class="p">)</span><span class="o">&lt;</span><span class="n">siz</span><span class="p">(</span><span class="mi">2</span><span class="p">),</span> <span class="n">V</span><span class="p">.</span><span class="n">n</span><span class="p">=</span><span class="n">V</span><span class="p">.</span><span class="n">n</span><span class="o">&#39;</span><span class="p">;</span> <span class="k">end</span><span class="p">;</span> <span class="k">end</span></div><div class='line' id='LC106'>&nbsp;&nbsp;&nbsp;&nbsp;<span class="k">end</span></div><div class='line' id='LC107'>&nbsp;&nbsp;&nbsp;&nbsp;</div><div class='line' id='LC108'>&nbsp;&nbsp;&nbsp;&nbsp;<span class="k">if</span> <span class="o">~</span><span class="n">isfield</span><span class="p">(</span><span class="n">V</span><span class="p">,</span><span class="s">&#39;est_sig&#39;</span><span class="p">),</span>   <span class="n">V</span><span class="p">.</span><span class="n">est_sig</span>   <span class="p">=</span> <span class="mi">0</span><span class="p">;</span> <span class="k">end</span>    <span class="c">% whether to estimate sig</span></div><div class='line' id='LC109'>&nbsp;&nbsp;&nbsp;&nbsp;<span class="k">if</span> <span class="o">~</span><span class="n">isfield</span><span class="p">(</span><span class="n">V</span><span class="p">,</span><span class="s">&#39;est_lam&#39;</span><span class="p">),</span>   <span class="n">V</span><span class="p">.</span><span class="n">est_lam</span>   <span class="p">=</span> <span class="mi">0</span><span class="p">;</span> <span class="k">end</span>    <span class="c">% whether to estimate lam</span></div><div class='line' id='LC110'>&nbsp;&nbsp;&nbsp;&nbsp;<span class="k">if</span> <span class="o">~</span><span class="n">isfield</span><span class="p">(</span><span class="n">V</span><span class="p">,</span><span class="s">&#39;est_gam&#39;</span><span class="p">),</span>   <span class="n">V</span><span class="p">.</span><span class="n">est_gam</span>   <span class="p">=</span> <span class="mi">0</span><span class="p">;</span> <span class="k">end</span>    <span class="c">% whether to estimate gam</span></div><div class='line' id='LC111'>&nbsp;&nbsp;&nbsp;&nbsp;<span class="k">if</span> <span class="o">~</span><span class="n">isfield</span><span class="p">(</span><span class="n">V</span><span class="p">,</span><span class="s">&#39;est_a&#39;</span><span class="p">),</span>     <span class="n">V</span><span class="p">.</span><span class="n">est_a</span>     <span class="p">=</span> <span class="mi">0</span><span class="p">;</span> <span class="k">end</span>    <span class="c">% whether to estimate a</span></div><div class='line' id='LC112'>&nbsp;&nbsp;&nbsp;&nbsp;<span class="k">if</span> <span class="o">~</span><span class="n">isfield</span><span class="p">(</span><span class="n">V</span><span class="p">,</span><span class="s">&#39;est_b&#39;</span><span class="p">),</span>     <span class="n">V</span><span class="p">.</span><span class="n">est_b</span>     <span class="p">=</span> <span class="mi">1</span><span class="p">;</span> <span class="k">end</span>    <span class="c">% whether to estimate b</span></div><div class='line' id='LC113'>&nbsp;&nbsp;&nbsp;&nbsp;<span class="k">if</span> <span class="o">~</span><span class="n">isfield</span><span class="p">(</span><span class="n">V</span><span class="p">,</span><span class="s">&#39;fast_plot&#39;</span><span class="p">),</span> <span class="n">V</span><span class="p">.</span><span class="n">fast_plot</span> <span class="p">=</span> <span class="mi">1</span><span class="p">;</span> <span class="k">end</span>    <span class="c">% whether to plot results from each iteration</span></div><div class='line' id='LC114'>&nbsp;&nbsp;&nbsp;&nbsp;<span class="k">if</span> <span class="o">~</span><span class="n">isfield</span><span class="p">(</span><span class="n">V</span><span class="p">,</span><span class="s">&#39;fast_thr&#39;</span><span class="p">),</span>  <span class="n">V</span><span class="p">.</span><span class="n">fast_thr</span>  <span class="p">=</span> <span class="mi">0</span><span class="p">;</span> <span class="k">end</span>    <span class="c">% whether to threshold spike train before estimating &#39;a&#39; and &#39;b&#39;</span></div><div class='line' id='LC115'>&nbsp;&nbsp;&nbsp;&nbsp;<span class="k">if</span> <span class="o">~</span><span class="n">isfield</span><span class="p">(</span><span class="n">V</span><span class="p">,</span><span class="s">&#39;fast_ignore_post&#39;</span><span class="p">),</span> <span class="n">V</span><span class="p">.</span><span class="n">fast_ignore_post</span><span class="p">=</span><span class="mi">0</span><span class="p">;</span> <span class="k">end</span> <span class="c">% whether to ignore the posterior, and just keep the last iteration</span></div><div class='line' id='LC116'><span class="k">end</span></div><div class='line' id='LC117'><br/></div><div class='line' id='LC118'><span class="c">% normalize F if it is only a trace</span></div><div class='line' id='LC119'><span class="k">if</span> <span class="n">V</span><span class="p">.</span><span class="n">Npixels</span><span class="o">==</span><span class="mi">1</span></div><div class='line' id='LC120'>&nbsp;&nbsp;&nbsp;&nbsp;<span class="n">F</span><span class="p">=</span><span class="n">detrend</span><span class="p">(</span><span class="n">F</span><span class="p">);</span></div><div class='line' id='LC121'>&nbsp;&nbsp;&nbsp;&nbsp;<span class="n">F</span><span class="p">=</span><span class="n">F</span><span class="o">-</span><span class="n">min</span><span class="p">(</span><span class="n">F</span><span class="p">)</span><span class="o">+</span><span class="nb">eps</span><span class="p">;</span></div><div class='line' id='LC122'><span class="k">end</span></div><div class='line' id='LC123'><br/></div><div class='line' id='LC124'><span class="c">%% set default model Parameters</span></div><div class='line' id='LC125'><br/></div><div class='line' id='LC126'><br/></div><div class='line' id='LC127'><br/></div><div class='line' id='LC128'><span class="k">if</span> <span class="n">nargin</span> <span class="o">&lt;</span> <span class="mi">3</span><span class="p">,</span>          <span class="n">P</span>       <span class="p">=</span> <span class="n">struct</span><span class="p">;</span>                       <span class="k">end</span></div><div class='line' id='LC129'><span class="k">if</span> <span class="o">~</span><span class="n">isfield</span><span class="p">(</span><span class="n">P</span><span class="p">,</span><span class="s">&#39;sig&#39;</span><span class="p">),</span>   <span class="n">P</span><span class="p">.</span><span class="n">sig</span>   <span class="p">=</span> <span class="n">mean</span><span class="p">(</span><span class="n">mad</span><span class="p">(</span><span class="n">F</span><span class="o">&#39;</span><span class="p">,</span><span class="mi">1</span><span class="p">)</span><span class="o">*</span><span class="mf">1.4826</span><span class="p">);</span>       <span class="k">end</span></div><div class='line' id='LC130'><span class="k">if</span> <span class="o">~</span><span class="n">isfield</span><span class="p">(</span><span class="n">P</span><span class="p">,</span><span class="s">&#39;gam&#39;</span><span class="p">),</span>   <span class="n">P</span><span class="p">.</span><span class="n">gam</span>   <span class="p">=</span> <span class="p">(</span><span class="mi">1</span><span class="o">-</span><span class="n">V</span><span class="p">.</span><span class="n">dt</span><span class="o">/</span><span class="mi">1</span><span class="p">)</span><span class="o">*</span><span class="nb">ones</span><span class="p">(</span><span class="n">V</span><span class="p">.</span><span class="n">Ncells</span><span class="p">,</span><span class="mi">1</span><span class="p">);</span>  <span class="k">end</span></div><div class='line' id='LC131'><span class="k">if</span> <span class="o">~</span><span class="n">isfield</span><span class="p">(</span><span class="n">P</span><span class="p">,</span><span class="s">&#39;lam&#39;</span><span class="p">),</span>   <span class="n">P</span><span class="p">.</span><span class="n">lam</span>   <span class="p">=</span> <span class="mi">10</span><span class="o">*</span><span class="nb">ones</span><span class="p">(</span><span class="n">V</span><span class="p">.</span><span class="n">Ncells</span><span class="p">,</span><span class="mi">1</span><span class="p">);</span>          <span class="k">end</span></div><div class='line' id='LC132'><span class="k">if</span> <span class="o">~</span><span class="n">isfield</span><span class="p">(</span><span class="n">P</span><span class="p">,</span><span class="s">&#39;a&#39;</span><span class="p">),</span>     <span class="n">P</span><span class="p">.</span><span class="n">a</span>     <span class="p">=</span> <span class="n">median</span><span class="p">(</span><span class="n">F</span><span class="p">,</span><span class="mi">2</span><span class="p">);</span>                  <span class="k">end</span></div><div class='line' id='LC133'><br/></div><div class='line' id='LC134'><span class="k">if</span> <span class="o">~</span><span class="n">isfield</span><span class="p">(</span><span class="n">P</span><span class="p">,</span><span class="s">&#39;b&#39;</span><span class="p">),</span></div><div class='line' id='LC135'>&nbsp;&nbsp;&nbsp;&nbsp;<span class="k">if</span> <span class="n">V</span><span class="p">.</span><span class="n">Npixels</span><span class="o">==</span><span class="mi">1</span><span class="p">,</span> <span class="n">P</span><span class="p">.</span><span class="n">b</span> <span class="p">=</span> <span class="n">quantile</span><span class="p">(</span><span class="n">F</span><span class="p">,</span><span class="mf">0.05</span><span class="p">);</span></div><div class='line' id='LC136'>&nbsp;&nbsp;&nbsp;&nbsp;<span class="k">else</span> <span class="n">P</span><span class="p">.</span><span class="n">b</span><span class="p">=</span><span class="n">median</span><span class="p">(</span><span class="n">F</span><span class="p">,</span><span class="mi">2</span><span class="p">);</span></div><div class='line' id='LC137'>&nbsp;&nbsp;&nbsp;&nbsp;<span class="k">end</span></div><div class='line' id='LC138'><span class="k">end</span>    </div><div class='line' id='LC139'>&nbsp;&nbsp;&nbsp;&nbsp;</div><div class='line' id='LC140'><span class="c">%% define some stuff needed for est_MAP function</span></div><div class='line' id='LC141'><br/></div><div class='line' id='LC142'><span class="c">% for brevity and expediency</span></div><div class='line' id='LC143'><span class="n">Z</span>   <span class="p">=</span> <span class="nb">zeros</span><span class="p">(</span><span class="n">V</span><span class="p">.</span><span class="n">Ncells</span><span class="o">*</span><span class="n">V</span><span class="p">.</span><span class="n">T</span><span class="p">,</span><span class="mi">1</span><span class="p">);</span>                    <span class="c">% zero vector</span></div><div class='line' id='LC144'><span class="n">M</span>   <span class="p">=</span> <span class="n">spdiags</span><span class="p">([</span><span class="nb">repmat</span><span class="p">(</span><span class="o">-</span><span class="n">P</span><span class="p">.</span><span class="n">gam</span><span class="p">,</span><span class="n">V</span><span class="p">.</span><span class="n">T</span><span class="p">,</span><span class="mi">1</span><span class="p">)</span> <span class="nb">repmat</span><span class="p">(</span><span class="n">Z</span><span class="p">,</span><span class="mi">1</span><span class="p">,</span><span class="n">V</span><span class="p">.</span><span class="n">Ncells</span><span class="o">-</span><span class="mi">1</span><span class="p">)</span> <span class="p">(</span><span class="mi">1</span><span class="o">+</span><span class="n">Z</span><span class="p">)],</span> <span class="o">-</span><span class="n">V</span><span class="p">.</span><span class="n">Ncells</span><span class="p">:</span><span class="mi">0</span><span class="p">,</span><span class="n">V</span><span class="p">.</span><span class="n">Ncells</span><span class="o">*</span><span class="n">V</span><span class="p">.</span><span class="n">T</span><span class="p">,</span><span class="n">V</span><span class="p">.</span><span class="n">Ncells</span><span class="o">*</span><span class="n">V</span><span class="p">.</span><span class="n">T</span><span class="p">);</span>  <span class="c">% matrix transforming calcium into spikes, ie n=M*C</span></div><div class='line' id='LC145'><span class="n">I</span>   <span class="p">=</span> <span class="n">speye</span><span class="p">(</span><span class="n">V</span><span class="p">.</span><span class="n">Ncells</span><span class="o">*</span><span class="n">V</span><span class="p">.</span><span class="n">T</span><span class="p">);</span>                      <span class="c">% create out here cuz it must be reused</span></div><div class='line' id='LC146'><span class="n">H1</span>  <span class="p">=</span> <span class="n">I</span><span class="p">;</span>                                        <span class="c">% initialize memory for Hessian matrix</span></div><div class='line' id='LC147'><span class="n">H2</span>  <span class="p">=</span> <span class="n">I</span><span class="p">;</span>                                        <span class="c">% initialize memory for other part of Hessian matrix</span></div><div class='line' id='LC148'><span class="n">d0</span>  <span class="p">=</span> <span class="mi">1</span><span class="p">:</span><span class="n">V</span><span class="p">.</span><span class="n">Ncells</span><span class="o">*</span><span class="n">V</span><span class="p">.</span><span class="n">T</span><span class="o">+</span><span class="mi">1</span><span class="p">:(</span><span class="n">V</span><span class="p">.</span><span class="n">Ncells</span><span class="o">*</span><span class="n">V</span><span class="p">.</span><span class="n">T</span><span class="p">)</span>^<span class="mi">2</span><span class="p">;</span>        <span class="c">% index of diagonal elements of TxT matrices</span></div><div class='line' id='LC149'><span class="n">d1</span>  <span class="p">=</span> <span class="mi">1</span><span class="o">+</span><span class="n">V</span><span class="p">.</span><span class="n">Ncells</span><span class="p">:</span><span class="n">V</span><span class="p">.</span><span class="n">Ncells</span><span class="o">*</span><span class="n">V</span><span class="p">.</span><span class="n">T</span><span class="o">+</span><span class="mi">1</span><span class="p">:(</span><span class="n">V</span><span class="p">.</span><span class="n">Ncells</span><span class="o">*</span><span class="n">V</span><span class="p">.</span><span class="n">T</span><span class="p">)</span><span class="o">*</span><span class="p">(</span><span class="n">V</span><span class="p">.</span><span class="n">Ncells</span><span class="o">*</span><span class="p">(</span><span class="n">V</span><span class="p">.</span><span class="n">T</span><span class="o">-</span><span class="mi">1</span><span class="p">));</span> <span class="c">% index of off-diagonal elements of TxT matrices</span></div><div class='line' id='LC150'><span class="n">posts</span> <span class="p">=</span> <span class="n">Z</span><span class="p">(</span><span class="mi">1</span><span class="p">:</span><span class="n">V</span><span class="p">.</span><span class="n">fast_iter_max</span><span class="p">);</span>                   <span class="c">% initialize likelihood</span></div><div class='line' id='LC151'><span class="k">if</span> <span class="nb">numel</span><span class="p">(</span><span class="n">P</span><span class="p">.</span><span class="n">lam</span><span class="p">)</span><span class="o">==</span><span class="n">V</span><span class="p">.</span><span class="n">Ncells</span></div><div class='line' id='LC152'>&nbsp;&nbsp;&nbsp;&nbsp;<span class="n">lam</span> <span class="p">=</span> <span class="n">V</span><span class="p">.</span><span class="n">dt</span><span class="o">*</span><span class="nb">repmat</span><span class="p">(</span><span class="n">P</span><span class="p">.</span><span class="n">lam</span><span class="p">,</span><span class="n">V</span><span class="p">.</span><span class="n">T</span><span class="p">,</span><span class="mi">1</span><span class="p">);</span>             <span class="c">% for lik</span></div><div class='line' id='LC153'><span class="k">elseif</span> <span class="nb">numel</span><span class="p">(</span><span class="n">P</span><span class="p">.</span><span class="n">lam</span><span class="p">)</span><span class="o">==</span><span class="n">V</span><span class="p">.</span><span class="n">Ncells</span><span class="o">*</span><span class="n">V</span><span class="p">.</span><span class="n">T</span></div><div class='line' id='LC154'>&nbsp;&nbsp;&nbsp;&nbsp;<span class="n">lam</span> <span class="p">=</span> <span class="n">V</span><span class="p">.</span><span class="n">dt</span><span class="o">*</span><span class="n">P</span><span class="p">.</span><span class="n">lam</span><span class="p">;</span></div><div class='line' id='LC155'><span class="k">else</span></div><div class='line' id='LC156'>&nbsp;&nbsp;&nbsp;&nbsp;<span class="n">error</span><span class="p">(</span><span class="s">&#39;lam must either be length V.T or 1&#39;</span><span class="p">);</span></div><div class='line' id='LC157'><span class="k">end</span></div><div class='line' id='LC158'><br/></div><div class='line' id='LC159'><span class="k">if</span> <span class="n">V</span><span class="p">.</span><span class="n">fast_poiss</span><span class="o">==</span><span class="mi">1</span></div><div class='line' id='LC160'>&nbsp;&nbsp;&nbsp;&nbsp;<span class="n">H</span>       <span class="p">=</span> <span class="n">I</span><span class="p">;</span>                                <span class="c">% initialize memory for Hessian matrix</span></div><div class='line' id='LC161'>&nbsp;&nbsp;&nbsp;&nbsp;<span class="n">gamlnF</span>  <span class="p">=</span> <span class="nb">gammaln</span><span class="p">(</span><span class="n">F</span><span class="o">+</span><span class="mi">1</span><span class="p">);</span>                     <span class="c">% for lik</span></div><div class='line' id='LC162'>&nbsp;&nbsp;&nbsp;&nbsp;<span class="n">sumF</span>    <span class="p">=</span> <span class="n">sum</span><span class="p">(</span><span class="n">F</span><span class="p">,</span><span class="mi">1</span><span class="p">)</span><span class="o">&#39;</span><span class="p">;</span>                        <span class="c">% for grad &amp; Hess</span></div><div class='line' id='LC163'><span class="k">end</span></div><div class='line' id='LC164'><br/></div><div class='line' id='LC165'><span class="c">%% if not iterating to estimate parameters, only this is necessary</span></div><div class='line' id='LC166'><span class="p">[</span><span class="n">n</span> <span class="n">C</span> <span class="n">posts</span><span class="p">(</span><span class="mi">1</span><span class="p">)]</span> <span class="p">=</span> <span class="n">est_MAP</span><span class="p">(</span><span class="n">F</span><span class="p">,</span><span class="n">P</span><span class="p">);</span></div><div class='line' id='LC167'><span class="n">n_best</span> <span class="p">=</span> <span class="n">n</span><span class="p">;</span></div><div class='line' id='LC168'><span class="n">P_best</span> <span class="p">=</span> <span class="n">P</span><span class="p">;</span></div><div class='line' id='LC169'><span class="n">V</span><span class="p">.</span><span class="n">fast_iter_tot</span> <span class="p">=</span> <span class="mi">1</span><span class="p">;</span></div><div class='line' id='LC170'><span class="n">V</span><span class="p">.</span><span class="n">post</span> <span class="p">=</span> <span class="n">posts</span><span class="p">(</span><span class="mi">1</span><span class="p">);</span></div><div class='line' id='LC171'><span class="n">post_max</span> <span class="p">=</span> <span class="n">posts</span><span class="p">(</span><span class="mi">1</span><span class="p">);</span></div><div class='line' id='LC172'><br/></div><div class='line' id='LC173'><span class="k">if</span> <span class="n">V</span><span class="p">.</span><span class="n">fast_iter_max</span><span class="o">&gt;</span><span class="mi">1</span></div><div class='line' id='LC174'>&nbsp;&nbsp;&nbsp;&nbsp;<span class="n">options</span> <span class="p">=</span> <span class="n">optimset</span><span class="p">(</span><span class="s">&#39;Display&#39;</span><span class="p">,</span><span class="s">&#39;off&#39;</span><span class="p">);</span>        <span class="c">% don&#39;t show warnings for parameter estimation</span></div><div class='line' id='LC175'>&nbsp;&nbsp;&nbsp;&nbsp;<span class="nb">i</span>       <span class="p">=</span> <span class="mi">1</span><span class="p">;</span>                                <span class="c">% iteration #</span></div><div class='line' id='LC176'>&nbsp;&nbsp;&nbsp;&nbsp;<span class="n">i_best</span>  <span class="p">=</span> <span class="nb">i</span><span class="p">;</span>                                <span class="c">% iteration with highest likelihood</span></div><div class='line' id='LC177'>&nbsp;&nbsp;&nbsp;&nbsp;<span class="n">conv</span>    <span class="p">=</span> <span class="mi">0</span><span class="p">;</span>                                <span class="c">% whether algorithm has converged yet</span></div><div class='line' id='LC178'><span class="k">else</span></div><div class='line' id='LC179'>&nbsp;&nbsp;&nbsp;&nbsp;<span class="n">conv</span>    <span class="p">=</span> <span class="mi">1</span><span class="p">;</span></div><div class='line' id='LC180'><span class="k">end</span></div><div class='line' id='LC181'><br/></div><div class='line' id='LC182'><span class="c">%%  if parameters are unknown, do pseudo-EM iterations</span></div><div class='line' id='LC183'><span class="k">while</span> <span class="n">conv</span> <span class="o">==</span> <span class="mi">0</span></div><div class='line' id='LC184'>&nbsp;&nbsp;&nbsp;&nbsp;<span class="k">if</span> <span class="n">V</span><span class="p">.</span><span class="n">fast_plot</span> <span class="o">==</span> <span class="mi">1</span><span class="p">,</span> <span class="n">MakePlot</span><span class="p">(</span><span class="n">n</span><span class="p">,</span><span class="n">F</span><span class="p">,</span><span class="n">P</span><span class="p">,</span><span class="n">V</span><span class="p">);</span> <span class="k">end</span> <span class="c">% plot results from previous iteration</span></div><div class='line' id='LC185'>&nbsp;&nbsp;&nbsp;&nbsp;<span class="nb">i</span>               <span class="p">=</span> <span class="nb">i</span><span class="o">+</span><span class="mi">1</span><span class="p">;</span>                      <span class="c">% update iteratation number</span></div><div class='line' id='LC186'>&nbsp;&nbsp;&nbsp;&nbsp;<span class="n">V</span><span class="p">.</span><span class="n">fast_iter_tot</span> <span class="p">=</span> <span class="nb">i</span><span class="p">;</span>                        <span class="c">% record of total # of iterations</span></div><div class='line' id='LC187'>&nbsp;&nbsp;&nbsp;&nbsp;<span class="n">P</span>               <span class="p">=</span> <span class="n">est_params</span><span class="p">(</span><span class="n">n</span><span class="p">,</span><span class="n">C</span><span class="p">,</span><span class="n">F</span><span class="p">,</span><span class="n">P</span><span class="p">,</span><span class="n">b</span><span class="p">);</span>    <span class="c">% update parameters based on previous iteration</span></div><div class='line' id='LC188'>&nbsp;&nbsp;&nbsp;&nbsp;<span class="p">[</span><span class="n">n</span> <span class="n">C</span> <span class="n">posts</span><span class="p">(</span><span class="nb">i</span><span class="p">)]</span>  <span class="p">=</span> <span class="n">est_MAP</span><span class="p">(</span><span class="n">F</span><span class="p">,</span><span class="n">P</span><span class="p">);</span>             <span class="c">% update inferred spike train based on new parameters</span></div><div class='line' id='LC189'>&nbsp;&nbsp;&nbsp;&nbsp;</div><div class='line' id='LC190'>&nbsp;&nbsp;&nbsp;&nbsp;<span class="k">if</span> <span class="n">posts</span><span class="p">(</span><span class="nb">i</span><span class="p">)</span><span class="o">&gt;</span><span class="n">post_max</span> <span class="o">||</span> <span class="n">V</span><span class="p">.</span><span class="n">fast_ignore_post</span><span class="o">==</span><span class="mi">1</span><span class="c">% if this is the best one, keep n and P</span></div><div class='line' id='LC191'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span class="n">n_best</span>  <span class="p">=</span> <span class="n">n</span><span class="p">;</span>                            <span class="c">% keep n</span></div><div class='line' id='LC192'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span class="n">P_best</span>  <span class="p">=</span> <span class="n">P</span><span class="p">;</span>                            <span class="c">% keep P</span></div><div class='line' id='LC193'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span class="n">i_best</span>  <span class="p">=</span> <span class="nb">i</span><span class="p">;</span>                            <span class="c">% keep track of which was best</span></div><div class='line' id='LC194'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span class="n">post_max</span><span class="p">=</span> <span class="n">posts</span><span class="p">(</span><span class="nb">i</span><span class="p">);</span>                     <span class="c">% keep max posterior</span></div><div class='line' id='LC195'>&nbsp;&nbsp;&nbsp;&nbsp;<span class="k">end</span></div><div class='line' id='LC196'>&nbsp;&nbsp;&nbsp;&nbsp;</div><div class='line' id='LC197'>&nbsp;&nbsp;&nbsp;&nbsp;<span class="c">% if lik doesn&#39;t change much (relatively), or returns to some previous state, stop iterating</span></div><div class='line' id='LC198'>&nbsp;&nbsp;&nbsp;&nbsp;<span class="k">if</span>  <span class="nb">i</span><span class="o">&gt;</span><span class="p">=</span><span class="n">V</span><span class="p">.</span><span class="n">fast_iter_max</span> <span class="o">||</span> <span class="p">(</span><span class="nb">abs</span><span class="p">((</span><span class="n">posts</span><span class="p">(</span><span class="nb">i</span><span class="p">)</span><span class="o">-</span><span class="n">posts</span><span class="p">(</span><span class="nb">i</span><span class="o">-</span><span class="mi">1</span><span class="p">))</span><span class="o">/</span><span class="n">posts</span><span class="p">(</span><span class="nb">i</span><span class="p">))</span><span class="o">&lt;</span><span class="mf">1e-3</span> <span class="o">||</span> <span class="n">any</span><span class="p">(</span><span class="n">posts</span><span class="p">(</span><span class="mi">1</span><span class="p">:</span><span class="nb">i</span><span class="o">-</span><span class="mi">1</span><span class="p">)</span><span class="o">-</span><span class="n">posts</span><span class="p">(</span><span class="nb">i</span><span class="p">))</span><span class="o">&lt;</span><span class="mf">1e-5</span><span class="p">)</span><span class="c">% abs((posts(i)-posts(i-1))/posts(i))&lt;1e-5 || posts(i-1)-posts(i)&gt;1e5;</span></div><div class='line' id='LC199'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span class="n">MakePlot</span><span class="p">(</span><span class="n">n</span><span class="p">,</span><span class="n">F</span><span class="p">,</span><span class="n">P</span><span class="p">,</span><span class="n">V</span><span class="p">);</span></div><div class='line' id='LC200'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span class="nb">disp</span><span class="p">(</span><span class="s">&#39;convergence criteria met&#39;</span><span class="p">)</span></div><div class='line' id='LC201'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span class="n">V</span><span class="p">.</span><span class="n">post</span>  <span class="p">=</span> <span class="n">posts</span><span class="p">(</span><span class="mi">1</span><span class="p">:</span><span class="nb">i</span><span class="p">);</span></div><div class='line' id='LC202'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span class="n">conv</span>    <span class="p">=</span> <span class="mi">1</span><span class="p">;</span></div><div class='line' id='LC203'>&nbsp;&nbsp;&nbsp;&nbsp;<span class="k">end</span></div><div class='line' id='LC204'>&nbsp;&nbsp;&nbsp;&nbsp;<span class="n">sound</span><span class="p">(</span><span class="mi">3</span><span class="o">*</span><span class="nb">sin</span><span class="p">(</span><span class="nb">linspace</span><span class="p">(</span><span class="mi">0</span><span class="p">,</span><span class="mi">90</span><span class="o">*</span><span class="nb">pi</span><span class="p">,</span><span class="mi">2000</span><span class="p">)))</span>        <span class="c">% play sound to indicate iteration is over</span></div><div class='line' id='LC205'><span class="k">end</span></div><div class='line' id='LC206'><br/></div><div class='line' id='LC207'><span class="n">V</span><span class="p">.</span><span class="n">fast_time</span> <span class="p">=</span> <span class="n">cputime</span><span class="o">-</span><span class="n">starttime</span><span class="p">;</span>                <span class="c">% time to run code</span></div><div class='line' id='LC208'><span class="n">V</span>           <span class="p">=</span> <span class="n">orderfields</span><span class="p">(</span><span class="n">V</span><span class="p">);</span>                   <span class="c">% order fields alphabetically to they are easier to read</span></div><div class='line' id='LC209'><span class="n">P_best</span>      <span class="p">=</span> <span class="n">orderfields</span><span class="p">(</span><span class="n">P_best</span><span class="p">);</span></div><div class='line' id='LC210'><span class="c">% n_best      = n_best./repmat(max(n_best),V.T,1);</span></div><div class='line' id='LC211'><br/></div><div class='line' id='LC212'><span class="n">P_best</span><span class="p">.</span><span class="nb">j</span><span class="p">=</span><span class="nb">j</span><span class="p">;</span></div><div class='line' id='LC213'><br/></div><div class='line' id='LC214'><span class="c">%% fast filter function</span></div><div class='line' id='LC215'><span class="k">    function</span><span class="w"> </span>[n C post] <span class="p">=</span><span class="w"> </span><span class="nf">est_MAP</span><span class="p">(</span>F,P<span class="p">)</span><span class="w"></span></div><div class='line' id='LC216'><span class="w">        </span></div><div class='line' id='LC217'><span class="w">        </span><span class="c">% initialize n and C</span></div><div class='line' id='LC218'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span class="n">z</span> <span class="p">=</span> <span class="mi">1</span><span class="p">;</span>                                  <span class="c">% weight on barrier function</span></div><div class='line' id='LC219'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span class="n">llam</span> <span class="p">=</span> <span class="nb">reshape</span><span class="p">(</span><span class="mf">1.</span><span class="o">/</span><span class="n">lam</span><span class="o">&#39;</span><span class="p">,</span><span class="mi">1</span><span class="p">,</span><span class="n">V</span><span class="p">.</span><span class="n">Ncells</span><span class="o">*</span><span class="n">V</span><span class="p">.</span><span class="n">T</span><span class="p">)</span><span class="o">&#39;</span><span class="p">;</span></div><div class='line' id='LC220'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span class="k">if</span> <span class="n">V</span><span class="p">.</span><span class="n">fast_nonlin</span><span class="o">==</span><span class="mi">1</span></div><div class='line' id='LC221'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span class="n">n</span> <span class="p">=</span> <span class="n">V</span><span class="p">.</span><span class="n">gauss_n</span><span class="p">;</span></div><div class='line' id='LC222'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span class="k">else</span></div><div class='line' id='LC223'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span class="n">n</span> <span class="p">=</span> <span class="mf">0.01</span><span class="o">+</span><span class="mi">0</span><span class="o">*</span><span class="n">llam</span><span class="p">;</span>                    <span class="c">% initialize spike train</span></div><div class='line' id='LC224'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span class="k">end</span></div><div class='line' id='LC225'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span class="n">C</span> <span class="p">=</span> <span class="mi">0</span><span class="o">*</span><span class="n">n</span><span class="p">;</span>                                <span class="c">% initialize calcium</span></div><div class='line' id='LC226'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span class="k">for</span> <span class="nb">j</span><span class="p">=</span><span class="mi">1</span><span class="p">:</span><span class="n">V</span><span class="p">.</span><span class="n">Ncells</span></div><div class='line' id='LC227'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span class="n">C</span><span class="p">(</span><span class="nb">j</span><span class="p">:</span><span class="n">V</span><span class="p">.</span><span class="n">Ncells</span><span class="p">:</span><span class="k">end</span><span class="p">)</span> <span class="p">=</span> <span class="n">filter</span><span class="p">(</span><span class="mi">1</span><span class="p">,[</span><span class="mi">1</span><span class="p">,</span> <span class="o">-</span><span class="n">P</span><span class="p">.</span><span class="n">gam</span><span class="p">(</span><span class="nb">j</span><span class="p">)],</span><span class="n">n</span><span class="p">(</span><span class="nb">j</span><span class="p">:</span><span class="n">V</span><span class="p">.</span><span class="n">Ncells</span><span class="p">:</span><span class="k">end</span><span class="p">));</span> <span class="c">%(1-P.gam(j))*P.b(j);</span></div><div class='line' id='LC228'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span class="k">end</span></div><div class='line' id='LC229'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</div><div class='line' id='LC230'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span class="c">% precompute parameters required for evaluating and maximizing likelihood</span></div><div class='line' id='LC231'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span class="n">b</span>           <span class="p">=</span> <span class="nb">repmat</span><span class="p">(</span><span class="n">P</span><span class="p">.</span><span class="n">b</span><span class="p">,</span><span class="mi">1</span><span class="p">,</span><span class="n">V</span><span class="p">.</span><span class="n">T</span><span class="p">);</span>       <span class="c">% for lik</span></div><div class='line' id='LC232'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span class="k">if</span> <span class="n">V</span><span class="p">.</span><span class="n">fast_poiss</span><span class="o">==</span><span class="mi">1</span></div><div class='line' id='LC233'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span class="n">suma</span>    <span class="p">=</span> <span class="n">sum</span><span class="p">(</span><span class="n">P</span><span class="p">.</span><span class="n">a</span><span class="p">);</span>                 <span class="c">% for grad</span></div><div class='line' id='LC234'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span class="k">else</span></div><div class='line' id='LC235'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span class="n">M</span><span class="p">(</span><span class="n">d1</span><span class="p">)</span>   <span class="p">=</span> <span class="o">-</span><span class="nb">repmat</span><span class="p">(</span><span class="n">P</span><span class="p">.</span><span class="n">gam</span><span class="p">,</span><span class="n">V</span><span class="p">.</span><span class="n">T</span><span class="o">-</span><span class="mi">1</span><span class="p">,</span><span class="mi">1</span><span class="p">);</span>   <span class="c">% matrix transforming calcium into spikes, ie n=M*C</span></div><div class='line' id='LC236'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span class="n">ba</span>      <span class="p">=</span> <span class="n">P</span><span class="p">.</span><span class="n">a</span><span class="o">&#39;*</span><span class="n">b</span><span class="p">;</span> <span class="n">ba</span><span class="p">=</span><span class="n">ba</span><span class="p">(:);</span>         <span class="c">% for grad</span></div><div class='line' id='LC237'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span class="n">aa</span>      <span class="p">=</span> <span class="nb">repmat</span><span class="p">(</span><span class="nb">diag</span><span class="p">(</span><span class="n">P</span><span class="p">.</span><span class="n">a</span><span class="o">&#39;*</span><span class="n">P</span><span class="p">.</span><span class="n">a</span><span class="p">),</span><span class="n">V</span><span class="p">.</span><span class="n">T</span><span class="p">,</span><span class="mi">1</span><span class="p">);</span><span class="c">% for grad</span></div><div class='line' id='LC238'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span class="n">aF</span>      <span class="p">=</span> <span class="n">P</span><span class="p">.</span><span class="n">a</span><span class="o">&#39;*</span><span class="n">F</span><span class="p">;</span> <span class="n">aF</span><span class="p">=</span><span class="n">aF</span><span class="p">(:);</span>         <span class="c">% for grad</span></div><div class='line' id='LC239'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span class="n">e</span>       <span class="p">=</span> <span class="mi">1</span><span class="o">/</span><span class="p">(</span><span class="mi">2</span><span class="o">*</span><span class="n">P</span><span class="p">.</span><span class="n">sig</span>^<span class="mi">2</span><span class="p">);</span>            <span class="c">% scale of variance</span></div><div class='line' id='LC240'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span class="n">H1</span><span class="p">(</span><span class="n">d0</span><span class="p">)</span>  <span class="p">=</span> <span class="o">-</span><span class="mi">2</span><span class="o">*</span><span class="n">e</span><span class="o">*</span><span class="n">aa</span><span class="p">;</span>                   <span class="c">% for Hess</span></div><div class='line' id='LC241'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span class="k">end</span></div><div class='line' id='LC242'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span class="n">grad_lnprior</span>  <span class="p">=</span> <span class="n">M</span><span class="o">&#39;*</span><span class="n">llam</span><span class="p">;</span>                  <span class="c">% for grad</span></div><div class='line' id='LC243'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</div><div class='line' id='LC244'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</div><div class='line' id='LC245'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span class="c">% find C = argmin_{C_z} lik + prior + barrier_z</span></div><div class='line' id='LC246'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span class="k">while</span> <span class="n">z</span><span class="o">&gt;</span><span class="mf">1e-13</span>                           <span class="c">% this is an arbitrary threshold</span></div><div class='line' id='LC247'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</div><div class='line' id='LC248'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span class="k">if</span> <span class="n">V</span><span class="p">.</span><span class="n">fast_poiss</span><span class="o">==</span><span class="mi">1</span></div><div class='line' id='LC249'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span class="n">Fexpect</span> <span class="p">=</span> <span class="n">P</span><span class="p">.</span><span class="n">a</span><span class="o">*</span><span class="p">(</span><span class="n">C</span><span class="o">+</span><span class="n">b</span><span class="o">&#39;</span><span class="p">)</span><span class="o">&#39;</span><span class="p">;</span>          <span class="c">% expected poisson observation rate</span></div><div class='line' id='LC250'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span class="n">lik</span> <span class="p">=</span> <span class="o">-</span><span class="n">sum</span><span class="p">(</span><span class="n">sum</span><span class="p">(</span><span class="o">-</span><span class="n">Fexpect</span><span class="o">+</span> <span class="n">F</span><span class="o">.*</span><span class="nb">log</span><span class="p">(</span><span class="n">Fexpect</span><span class="p">)</span> <span class="o">-</span> <span class="n">gamlnF</span><span class="p">));</span> <span class="c">% lik</span></div><div class='line' id='LC251'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span class="k">else</span></div><div class='line' id='LC252'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span class="k">if</span> <span class="n">V</span><span class="p">.</span><span class="n">fast_nonlin</span><span class="o">==</span><span class="mi">1</span></div><div class='line' id='LC253'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span class="n">S</span> <span class="p">=</span> <span class="n">C</span><span class="o">./</span><span class="p">(</span><span class="n">C</span><span class="o">+</span><span class="n">P</span><span class="p">.</span><span class="n">k_d</span><span class="p">);</span></div><div class='line' id='LC254'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span class="k">else</span></div><div class='line' id='LC255'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span class="n">S</span> <span class="p">=</span> <span class="n">C</span><span class="p">;</span></div><div class='line' id='LC256'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span class="k">end</span></div><div class='line' id='LC257'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span class="n">D</span> <span class="p">=</span> <span class="n">F</span><span class="o">-</span><span class="n">P</span><span class="p">.</span><span class="n">a</span><span class="o">*</span><span class="p">(</span><span class="nb">reshape</span><span class="p">(</span><span class="n">S</span><span class="p">,</span><span class="n">V</span><span class="p">.</span><span class="n">Ncells</span><span class="p">,</span><span class="n">V</span><span class="p">.</span><span class="n">T</span><span class="p">))</span><span class="o">-</span><span class="n">b</span><span class="p">;</span> <span class="c">% difference vector to be used in likelihood computation</span></div><div class='line' id='LC258'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span class="n">lik</span> <span class="p">=</span> <span class="n">e</span><span class="o">*</span><span class="n">D</span><span class="p">(:)</span><span class="o">&#39;*</span><span class="n">D</span><span class="p">(:);</span>             <span class="c">% lik</span></div><div class='line' id='LC259'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span class="k">end</span></div><div class='line' id='LC260'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span class="n">post</span> <span class="p">=</span> <span class="n">lik</span> <span class="o">+</span> <span class="n">llam</span><span class="o">&#39;*</span><span class="n">n</span> <span class="o">-</span> <span class="n">z</span><span class="o">*</span><span class="n">sum</span><span class="p">(</span><span class="nb">log</span><span class="p">(</span><span class="n">n</span><span class="p">));</span></div><div class='line' id='LC261'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span class="n">s</span>    <span class="p">=</span> <span class="mi">1</span><span class="p">;</span>                           <span class="c">% step size</span></div><div class='line' id='LC262'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span class="n">d</span>    <span class="p">=</span> <span class="mi">1</span><span class="p">;</span>                           <span class="c">% direction</span></div><div class='line' id='LC263'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span class="k">while</span> <span class="n">norm</span><span class="p">(</span><span class="n">d</span><span class="p">)</span><span class="o">&gt;</span><span class="mf">5e-2</span> <span class="o">&amp;&amp;</span> <span class="n">s</span> <span class="o">&gt;</span> <span class="mf">1e-3</span>      <span class="c">% converge for this z (again, these thresholds are arbitrary)</span></div><div class='line' id='LC264'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span class="k">if</span> <span class="n">V</span><span class="p">.</span><span class="n">fast_poiss</span><span class="o">==</span><span class="mi">1</span></div><div class='line' id='LC265'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span class="n">glik</span>    <span class="p">=</span> <span class="n">suma</span> <span class="o">-</span> <span class="n">sumF</span><span class="o">./</span><span class="p">(</span><span class="n">C</span><span class="o">+</span><span class="n">b</span><span class="o">&#39;</span><span class="p">);</span></div><div class='line' id='LC266'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span class="n">H1</span><span class="p">(</span><span class="n">d0</span><span class="p">)</span>  <span class="p">=</span> <span class="n">sumF</span><span class="o">.*</span><span class="p">(</span><span class="n">C</span><span class="o">+</span><span class="n">b</span><span class="o">&#39;</span><span class="p">)</span><span class="o">.^</span><span class="p">(</span><span class="o">-</span><span class="mi">2</span><span class="p">);</span> <span class="c">% lik contribution to Hessian</span></div><div class='line' id='LC267'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span class="k">elseif</span> <span class="n">V</span><span class="p">.</span><span class="n">fast_nonlin</span><span class="o">==</span><span class="mi">1</span></div><div class='line' id='LC268'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span class="n">glik</span>    <span class="p">=</span> <span class="o">-</span><span class="mi">2</span><span class="o">*</span><span class="n">P</span><span class="p">.</span><span class="n">a</span><span class="o">*</span><span class="n">P</span><span class="p">.</span><span class="n">k_d</span><span class="o">*</span><span class="n">D</span><span class="o">&#39;.*</span><span class="p">(</span><span class="n">C</span><span class="o">+</span><span class="n">P</span><span class="p">.</span><span class="n">k_d</span><span class="p">)</span><span class="o">.^-</span><span class="mi">2</span><span class="p">;</span></div><div class='line' id='LC269'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span class="n">H1diag</span>  <span class="p">=</span> <span class="p">(</span><span class="o">-</span><span class="n">P</span><span class="p">.</span><span class="n">a</span><span class="o">*</span><span class="n">P</span><span class="p">.</span><span class="n">k_d</span><span class="o">-</span><span class="mi">2</span><span class="o">*</span><span class="p">(</span><span class="n">C</span><span class="o">+</span><span class="n">P</span><span class="p">.</span><span class="n">k_d</span><span class="p">)</span><span class="o">.*</span><span class="n">D</span><span class="o">&#39;</span><span class="p">)</span><span class="o">.*</span><span class="p">((</span><span class="n">C</span><span class="o">+</span><span class="n">P</span><span class="p">.</span><span class="n">k_d</span><span class="p">)</span><span class="o">.^-</span><span class="mi">4</span><span class="p">);</span></div><div class='line' id='LC270'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span class="n">H1</span><span class="p">(</span><span class="n">d0</span><span class="p">)</span>  <span class="p">=</span> <span class="n">H1diag</span><span class="p">;</span></div><div class='line' id='LC271'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span class="k">else</span></div><div class='line' id='LC272'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span class="n">glik</span>    <span class="p">=</span> <span class="o">-</span><span class="mi">2</span><span class="o">*</span><span class="n">e</span><span class="o">*</span><span class="p">(</span><span class="n">aF</span><span class="o">-</span><span class="n">aa</span><span class="o">.*</span><span class="n">C</span><span class="o">-</span><span class="n">ba</span><span class="p">);</span>  <span class="c">% gradient</span></div><div class='line' id='LC273'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span class="k">end</span></div><div class='line' id='LC274'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span class="n">g</span>       <span class="p">=</span> <span class="n">glik</span> <span class="o">+</span> <span class="n">grad_lnprior</span> <span class="o">-</span> <span class="n">z</span><span class="o">*</span><span class="n">M</span><span class="o">&#39;*</span><span class="p">(</span><span class="n">n</span><span class="o">.^-</span><span class="mi">1</span><span class="p">);</span></div><div class='line' id='LC275'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span class="n">H2</span><span class="p">(</span><span class="n">d0</span><span class="p">)</span>  <span class="p">=</span> <span class="n">n</span><span class="o">.^-</span><span class="mi">2</span><span class="p">;</span>                <span class="c">% log barrier part of the Hessian</span></div><div class='line' id='LC276'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span class="n">H</span>       <span class="p">=</span> <span class="n">H1</span> <span class="o">-</span> <span class="n">z</span><span class="o">*</span><span class="p">(</span><span class="n">M</span><span class="o">&#39;*</span><span class="n">H2</span><span class="o">*</span><span class="n">M</span><span class="p">);</span>     <span class="c">% Hessian</span></div><div class='line' id='LC277'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span class="n">d</span>   <span class="p">=</span> <span class="n">H</span><span class="o">\</span><span class="n">g</span><span class="p">;</span>                     <span class="c">% direction to step using newton-raphson</span></div><div class='line' id='LC278'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span class="n">hit</span> <span class="p">=</span> <span class="o">-</span><span class="n">n</span><span class="o">./</span><span class="p">(</span><span class="n">M</span><span class="o">*</span><span class="n">d</span><span class="p">);</span>                <span class="c">% step within constraint boundaries</span></div><div class='line' id='LC279'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span class="n">hit</span><span class="p">=</span><span class="n">hit</span><span class="p">(</span><span class="n">hit</span><span class="o">&gt;</span><span class="mi">0</span><span class="p">);</span></div><div class='line' id='LC280'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span class="k">if</span> <span class="n">any</span><span class="p">(</span><span class="n">hit</span><span class="o">&lt;</span><span class="mi">1</span><span class="p">)</span></div><div class='line' id='LC281'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span class="n">s</span> <span class="p">=</span> <span class="n">min</span><span class="p">(</span><span class="mi">1</span><span class="p">,</span><span class="mf">0.99</span><span class="o">*</span><span class="n">min</span><span class="p">(</span><span class="n">hit</span><span class="p">));</span></div><div class='line' id='LC282'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span class="k">else</span></div><div class='line' id='LC283'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span class="n">s</span> <span class="p">=</span> <span class="mi">1</span><span class="p">;</span></div><div class='line' id='LC284'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span class="k">end</span></div><div class='line' id='LC285'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span class="n">post1</span> <span class="p">=</span> <span class="n">post</span><span class="o">+</span><span class="mi">1</span><span class="p">;</span></div><div class='line' id='LC286'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span class="k">while</span> <span class="n">post1</span><span class="o">&gt;</span><span class="p">=</span><span class="n">post</span><span class="o">+</span><span class="mf">1e-7</span>          <span class="c">% make sure newton step doesn&#39;t increase objective</span></div><div class='line' id='LC287'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span class="n">C1</span>  <span class="p">=</span> <span class="n">C</span><span class="o">+</span><span class="n">s</span><span class="o">*</span><span class="n">d</span><span class="p">;</span></div><div class='line' id='LC288'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span class="n">n</span>   <span class="p">=</span> <span class="n">M</span><span class="o">*</span><span class="n">C1</span><span class="p">;</span></div><div class='line' id='LC289'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span class="k">if</span> <span class="n">V</span><span class="p">.</span><span class="n">fast_poiss</span><span class="o">==</span><span class="mi">1</span></div><div class='line' id='LC290'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span class="n">Fexpect</span> <span class="p">=</span> <span class="n">P</span><span class="p">.</span><span class="n">a</span><span class="o">*</span><span class="p">(</span><span class="n">C1</span><span class="o">+</span><span class="n">b</span><span class="o">&#39;</span><span class="p">)</span><span class="o">&#39;</span><span class="p">;</span></div><div class='line' id='LC291'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span class="n">lik1</span>    <span class="p">=</span> <span class="o">-</span><span class="n">sum</span><span class="p">(</span><span class="n">sum</span><span class="p">(</span><span class="o">-</span><span class="n">Fexpect</span><span class="o">+</span> <span class="n">F</span><span class="o">.*</span><span class="nb">log</span><span class="p">(</span><span class="n">Fexpect</span><span class="p">)</span> <span class="o">-</span> <span class="n">gamlnF</span><span class="p">));</span></div><div class='line' id='LC292'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span class="k">else</span></div><div class='line' id='LC293'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span class="k">if</span> <span class="n">V</span><span class="p">.</span><span class="n">fast_nonlin</span><span class="o">==</span><span class="mi">1</span></div><div class='line' id='LC294'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span class="n">S1</span> <span class="p">=</span> <span class="n">C1</span><span class="o">./</span><span class="p">(</span><span class="n">C1</span><span class="o">+</span><span class="n">P</span><span class="p">.</span><span class="n">k_d</span><span class="p">);</span></div><div class='line' id='LC295'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span class="k">else</span></div><div class='line' id='LC296'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span class="n">S1</span> <span class="p">=</span> <span class="n">C1</span><span class="p">;</span></div><div class='line' id='LC297'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span class="k">end</span></div><div class='line' id='LC298'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span class="n">D</span> <span class="p">=</span> <span class="n">F</span><span class="o">-</span><span class="n">P</span><span class="p">.</span><span class="n">a</span><span class="o">*</span><span class="p">(</span><span class="nb">reshape</span><span class="p">(</span><span class="n">S1</span><span class="p">,</span><span class="n">V</span><span class="p">.</span><span class="n">Ncells</span><span class="p">,</span><span class="n">V</span><span class="p">.</span><span class="n">T</span><span class="p">))</span><span class="o">-</span><span class="n">b</span><span class="p">;</span> <span class="c">% difference vector to be used in likelihood computation</span></div><div class='line' id='LC299'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span class="n">lik1</span> <span class="p">=</span> <span class="n">e</span><span class="o">*</span><span class="n">D</span><span class="p">(:)</span><span class="o">&#39;*</span><span class="n">D</span><span class="p">(:);</span>             <span class="c">% lik</span></div><div class='line' id='LC300'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span class="k">end</span></div><div class='line' id='LC301'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span class="n">post1</span> <span class="p">=</span> <span class="n">lik1</span> <span class="o">+</span> <span class="n">llam</span><span class="o">&#39;*</span><span class="n">n</span> <span class="o">-</span> <span class="n">z</span><span class="o">*</span><span class="n">sum</span><span class="p">(</span><span class="nb">log</span><span class="p">(</span><span class="n">n</span><span class="p">));</span></div><div class='line' id='LC302'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span class="n">s</span>   <span class="p">=</span> <span class="n">s</span><span class="o">/</span><span class="mi">5</span><span class="p">;</span>                  <span class="c">% if step increases objective function, decrease step size</span></div><div class='line' id='LC303'><br/></div><div class='line' id='LC304'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span class="k">if</span> <span class="n">s</span><span class="o">&lt;</span><span class="mf">1e-20</span><span class="p">;</span> <span class="nb">disp</span><span class="p">(</span><span class="s">&#39;reducing s further did not increase likelihood&#39;</span><span class="p">),</span> <span class="k">break</span><span class="p">;</span> <span class="k">end</span>      <span class="c">% if decreasing step size just doesn&#39;t do it</span></div><div class='line' id='LC305'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span class="k">end</span></div><div class='line' id='LC306'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span class="n">C</span>    <span class="p">=</span> <span class="n">C1</span><span class="p">;</span>                      <span class="c">% update C</span></div><div class='line' id='LC307'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span class="n">post</span> <span class="p">=</span> <span class="n">post1</span><span class="p">;</span>                   <span class="c">% update post</span></div><div class='line' id='LC308'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span class="k">end</span></div><div class='line' id='LC309'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span class="n">z</span><span class="p">=</span><span class="n">z</span><span class="o">/</span><span class="mi">10</span><span class="p">;</span>                             <span class="c">% reduce z (sequence of z reductions is arbitrary)</span></div><div class='line' id='LC310'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span class="k">end</span></div><div class='line' id='LC311'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</div><div class='line' id='LC312'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span class="c">% reshape things in the case of multiple neurons within the ROI</span></div><div class='line' id='LC313'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span class="n">n</span><span class="p">=</span><span class="nb">reshape</span><span class="p">(</span><span class="n">n</span><span class="p">,</span><span class="n">V</span><span class="p">.</span><span class="n">Ncells</span><span class="p">,</span><span class="n">V</span><span class="p">.</span><span class="n">T</span><span class="p">)</span><span class="o">&#39;</span><span class="p">;</span></div><div class='line' id='LC314'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span class="n">C</span><span class="p">=</span><span class="nb">reshape</span><span class="p">(</span><span class="n">C</span><span class="p">,</span><span class="n">V</span><span class="p">.</span><span class="n">Ncells</span><span class="p">,</span><span class="n">V</span><span class="p">.</span><span class="n">T</span><span class="p">)</span><span class="o">&#39;</span><span class="p">;</span></div><div class='line' id='LC315'>&nbsp;&nbsp;&nbsp;&nbsp;<span class="k">end</span></div><div class='line' id='LC316'><br/></div><div class='line' id='LC317'><span class="c">%% Parameter Update</span></div><div class='line' id='LC318'><span class="k">    function</span><span class="w"> </span>P <span class="p">=</span><span class="w"> </span><span class="nf">est_params</span><span class="p">(</span>n,C,F,P,b<span class="p">)</span><span class="w"></span></div><div class='line' id='LC319'><span class="w">        </span></div><div class='line' id='LC320'><span class="w">        </span><span class="c">% generate regressor for spatial filter</span></div><div class='line' id='LC321'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span class="k">if</span> <span class="n">V</span><span class="p">.</span><span class="n">est_a</span><span class="o">==</span><span class="mi">1</span> <span class="o">||</span> <span class="n">V</span><span class="p">.</span><span class="n">est_b</span><span class="o">==</span><span class="mi">1</span></div><div class='line' id='LC322'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span class="k">if</span> <span class="n">V</span><span class="p">.</span><span class="n">fast_thr</span><span class="o">==</span><span class="mi">1</span></div><div class='line' id='LC323'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span class="n">CC</span><span class="p">=</span><span class="mi">0</span><span class="o">*</span><span class="n">C</span><span class="p">;</span></div><div class='line' id='LC324'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span class="k">for</span> <span class="nb">j</span><span class="p">=</span><span class="mi">1</span><span class="p">:</span><span class="n">V</span><span class="p">.</span><span class="n">Ncells</span></div><div class='line' id='LC325'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span class="n">nsort</span>   <span class="p">=</span> <span class="n">sort</span><span class="p">(</span><span class="n">n</span><span class="p">(:,</span><span class="nb">j</span><span class="p">));</span></div><div class='line' id='LC326'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span class="n">nthr</span>    <span class="p">=</span> <span class="n">nsort</span><span class="p">(</span><span class="nb">round</span><span class="p">(</span><span class="mf">0.98</span><span class="o">*</span><span class="n">V</span><span class="p">.</span><span class="n">T</span><span class="p">));</span></div><div class='line' id='LC327'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span class="n">nn</span>      <span class="p">=</span> <span class="n">Z</span><span class="p">(</span><span class="mi">1</span><span class="p">:</span><span class="n">V</span><span class="p">.</span><span class="n">T</span><span class="p">);</span></div><div class='line' id='LC328'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span class="n">nn</span><span class="p">(</span><span class="n">n</span><span class="p">(:,</span><span class="nb">j</span><span class="p">)</span><span class="o">&lt;</span><span class="p">=</span><span class="n">nthr</span><span class="p">)=</span><span class="mi">0</span><span class="p">;</span></div><div class='line' id='LC329'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span class="n">nn</span><span class="p">(</span><span class="n">n</span><span class="p">(:,</span><span class="nb">j</span><span class="p">)</span><span class="o">&gt;</span><span class="n">nthr</span><span class="p">)=</span><span class="mi">1</span><span class="p">;</span></div><div class='line' id='LC330'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span class="n">CC</span><span class="p">(:,</span><span class="nb">j</span><span class="p">)</span> <span class="p">=</span> <span class="n">filter</span><span class="p">(</span><span class="mi">1</span><span class="p">,[</span><span class="mi">1</span> <span class="o">-</span><span class="n">P</span><span class="p">.</span><span class="n">gam</span><span class="p">(</span><span class="nb">j</span><span class="p">)],</span><span class="n">nn</span><span class="p">)</span> <span class="o">+</span> <span class="p">(</span><span class="mi">1</span><span class="o">-</span><span class="n">P</span><span class="p">.</span><span class="n">gam</span><span class="p">(</span><span class="nb">j</span><span class="p">))</span><span class="o">*</span><span class="n">P</span><span class="p">.</span><span class="n">b</span><span class="p">(</span><span class="nb">j</span><span class="p">);</span></div><div class='line' id='LC331'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span class="k">end</span></div><div class='line' id='LC332'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span class="k">else</span></div><div class='line' id='LC333'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span class="n">CC</span>      <span class="p">=</span> <span class="n">C</span><span class="p">;</span></div><div class='line' id='LC334'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span class="k">end</span></div><div class='line' id='LC335'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</div><div class='line' id='LC336'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span class="k">if</span> <span class="n">V</span><span class="p">.</span><span class="n">est_b</span><span class="o">==</span><span class="mi">1</span></div><div class='line' id='LC337'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span class="n">A</span> <span class="p">=</span> <span class="p">[</span><span class="n">CC</span> <span class="o">-</span><span class="mi">1</span><span class="o">+</span><span class="n">Z</span><span class="p">(</span><span class="mi">1</span><span class="p">:</span><span class="n">V</span><span class="p">.</span><span class="n">T</span><span class="p">)];</span></div><div class='line' id='LC338'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span class="k">else</span></div><div class='line' id='LC339'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span class="n">A</span><span class="p">=</span><span class="n">CC</span><span class="p">;</span></div><div class='line' id='LC340'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span class="k">end</span></div><div class='line' id='LC341'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span class="n">X</span> <span class="p">=</span> <span class="n">A</span><span class="o">\</span><span class="n">F</span><span class="o">&#39;</span><span class="p">;</span></div><div class='line' id='LC342'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</div><div class='line' id='LC343'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span class="n">P</span><span class="p">.</span><span class="n">a</span> <span class="p">=</span> <span class="n">X</span><span class="p">(</span><span class="mi">1</span><span class="p">:</span><span class="n">V</span><span class="p">.</span><span class="n">Ncells</span><span class="p">,:)</span><span class="o">&#39;</span><span class="p">;</span></div><div class='line' id='LC344'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span class="k">if</span> <span class="n">V</span><span class="p">.</span><span class="n">est_b</span><span class="o">==</span><span class="mi">1</span></div><div class='line' id='LC345'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span class="n">P</span><span class="p">.</span><span class="n">b</span> <span class="p">=</span> <span class="n">X</span><span class="p">(</span><span class="k">end</span><span class="p">,:)</span><span class="o">&#39;</span><span class="p">;</span></div><div class='line' id='LC346'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span class="n">b</span>   <span class="p">=</span> <span class="nb">repmat</span><span class="p">(</span><span class="n">P</span><span class="p">.</span><span class="n">b</span><span class="p">,</span><span class="mi">1</span><span class="p">,</span><span class="n">V</span><span class="p">.</span><span class="n">T</span><span class="p">);</span></div><div class='line' id='LC347'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span class="k">end</span></div><div class='line' id='LC348'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</div><div class='line' id='LC349'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span class="n">D</span>   <span class="p">=</span> <span class="n">F</span><span class="o">-</span><span class="n">P</span><span class="p">.</span><span class="n">a</span><span class="o">*</span><span class="p">(</span><span class="nb">reshape</span><span class="p">(</span><span class="n">C</span><span class="p">,</span><span class="n">V</span><span class="p">.</span><span class="n">Ncells</span><span class="p">,</span><span class="n">V</span><span class="p">.</span><span class="n">T</span><span class="p">))</span> <span class="o">-</span> <span class="n">b</span><span class="p">;</span></div><div class='line' id='LC350'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</div><div class='line' id='LC351'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span class="n">mse</span> <span class="p">=</span> <span class="n">D</span><span class="p">(:)</span><span class="o">&#39;*</span><span class="n">D</span><span class="p">(:);</span></div><div class='line' id='LC352'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span class="k">end</span></div><div class='line' id='LC353'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</div><div class='line' id='LC354'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span class="k">if</span> <span class="n">V</span><span class="p">.</span><span class="n">est_a</span><span class="o">==</span><span class="mi">0</span> <span class="o">&amp;&amp;</span> <span class="n">V</span><span class="p">.</span><span class="n">est_b</span><span class="o">==</span><span class="mi">0</span> <span class="o">&amp;&amp;</span> <span class="p">(</span><span class="n">V</span><span class="p">.</span><span class="n">est_sig</span><span class="o">==</span><span class="mi">1</span> <span class="o">||</span> <span class="n">V</span><span class="p">.</span><span class="n">est_lam</span><span class="o">==</span><span class="mi">1</span><span class="p">),</span></div><div class='line' id='LC355'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span class="n">D</span>   <span class="p">=</span> <span class="n">F</span><span class="o">-</span><span class="n">P</span><span class="p">.</span><span class="n">a</span><span class="o">*</span><span class="p">(</span><span class="nb">reshape</span><span class="p">(</span><span class="n">C</span><span class="p">,</span><span class="n">V</span><span class="p">.</span><span class="n">Ncells</span><span class="p">,</span><span class="n">V</span><span class="p">.</span><span class="n">T</span><span class="p">)</span><span class="o">+</span><span class="n">b</span><span class="p">);</span></div><div class='line' id='LC356'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span class="n">mse</span> <span class="p">=</span> <span class="n">D</span><span class="p">(:)</span><span class="o">&#39;*</span><span class="n">D</span><span class="p">(:);</span></div><div class='line' id='LC357'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span class="k">end</span></div><div class='line' id='LC358'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</div><div class='line' id='LC359'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span class="c">% estimate other parameters</span></div><div class='line' id='LC360'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span class="k">if</span> <span class="n">V</span><span class="p">.</span><span class="n">est_sig</span><span class="o">==</span><span class="mi">1</span><span class="p">,</span></div><div class='line' id='LC361'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span class="n">P</span><span class="p">.</span><span class="n">sig</span> <span class="p">=</span> <span class="nb">sqrt</span><span class="p">(</span><span class="n">mse</span><span class="p">)</span><span class="o">/</span><span class="n">V</span><span class="p">.</span><span class="n">T</span><span class="p">;</span></div><div class='line' id='LC362'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span class="k">end</span></div><div class='line' id='LC363'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span class="k">if</span> <span class="n">V</span><span class="p">.</span><span class="n">est_lam</span><span class="o">==</span><span class="mi">1</span><span class="p">,</span></div><div class='line' id='LC364'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span class="n">nnorm</span>   <span class="p">=</span> <span class="n">n</span><span class="o">./</span><span class="nb">repmat</span><span class="p">(</span><span class="n">max</span><span class="p">(</span><span class="n">n</span><span class="p">),</span><span class="n">V</span><span class="p">.</span><span class="n">T</span><span class="p">,</span><span class="mi">1</span><span class="p">);</span></div><div class='line' id='LC365'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span class="k">if</span> <span class="nb">numel</span><span class="p">(</span><span class="n">P</span><span class="p">.</span><span class="n">lam</span><span class="p">)</span><span class="o">==</span><span class="n">V</span><span class="p">.</span><span class="n">Ncells</span></div><div class='line' id='LC366'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span class="n">P</span><span class="p">.</span><span class="n">lam</span>   <span class="p">=</span> <span class="n">sum</span><span class="p">(</span><span class="n">nnorm</span><span class="p">)</span><span class="o">&#39;/</span><span class="p">(</span><span class="n">V</span><span class="p">.</span><span class="n">T</span><span class="o">*</span><span class="n">V</span><span class="p">.</span><span class="n">dt</span><span class="p">);</span></div><div class='line' id='LC367'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span class="n">lam</span>     <span class="p">=</span> <span class="nb">repmat</span><span class="p">(</span><span class="n">P</span><span class="p">.</span><span class="n">lam</span><span class="p">,</span><span class="n">V</span><span class="p">.</span><span class="n">T</span><span class="p">,</span><span class="mi">1</span><span class="p">)</span><span class="o">*</span><span class="n">V</span><span class="p">.</span><span class="n">dt</span><span class="p">;</span></div><div class='line' id='LC368'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span class="k">else</span></div><div class='line' id='LC369'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span class="n">P</span><span class="p">.</span><span class="n">lam</span>   <span class="p">=</span> <span class="n">nnorm</span><span class="o">/</span><span class="p">(</span><span class="n">V</span><span class="p">.</span><span class="n">T</span><span class="o">*</span><span class="n">V</span><span class="p">.</span><span class="n">dt</span><span class="p">);</span></div><div class='line' id='LC370'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span class="n">lam</span>     <span class="p">=</span> <span class="n">P</span><span class="p">.</span><span class="n">lam</span><span class="o">*</span><span class="n">V</span><span class="p">.</span><span class="n">dt</span><span class="p">;</span></div><div class='line' id='LC371'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span class="k">end</span></div><div class='line' id='LC372'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</div><div class='line' id='LC373'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span class="k">end</span></div><div class='line' id='LC374'>&nbsp;&nbsp;&nbsp;&nbsp;<span class="k">end</span></div><div class='line' id='LC375'><br/></div><div class='line' id='LC376'><span class="c">%% MakePlot</span></div><div class='line' id='LC377'><span class="k">    function</span><span class="w"> </span><span class="nf">MakePlot</span><span class="p">(</span>n,F,P,V<span class="p">)</span><span class="w"></span></div><div class='line' id='LC378'><span class="w">        </span><span class="k">if</span> <span class="n">V</span><span class="p">.</span><span class="n">fast_plot</span> <span class="o">==</span> <span class="mi">1</span></div><div class='line' id='LC379'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span class="k">if</span> <span class="n">V</span><span class="p">.</span><span class="n">Npixels</span><span class="o">&gt;</span><span class="mi">1</span>                                     <span class="c">% plot spatial filter</span></div><div class='line' id='LC380'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span class="n">figure</span><span class="p">(</span><span class="n">FigNum</span><span class="p">),</span> <span class="n">nrows</span><span class="p">=</span><span class="n">V</span><span class="p">.</span><span class="n">Ncells</span><span class="p">;</span></div><div class='line' id='LC381'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span class="k">for</span> <span class="nb">j</span><span class="p">=</span><span class="mi">1</span><span class="p">:</span><span class="n">V</span><span class="p">.</span><span class="n">Ncells</span><span class="p">,</span> <span class="n">subplot</span><span class="p">(</span><span class="mi">1</span><span class="p">,</span><span class="n">nrows</span><span class="p">,</span><span class="nb">j</span><span class="p">),</span></div><div class='line' id='LC382'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span class="n">imagesc</span><span class="p">(</span><span class="nb">reshape</span><span class="p">(</span><span class="n">P</span><span class="p">.</span><span class="n">a</span><span class="p">(:,</span><span class="nb">j</span><span class="p">),</span><span class="n">V</span><span class="p">.</span><span class="n">w</span><span class="p">,</span><span class="n">V</span><span class="p">.</span><span class="n">h</span><span class="p">)),</span></div><div class='line' id='LC383'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span class="n">title</span><span class="p">(</span><span class="s">&#39;a&#39;</span><span class="p">)</span></div><div class='line' id='LC384'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span class="k">end</span></div><div class='line' id='LC385'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span class="k">end</span></div><div class='line' id='LC386'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</div><div class='line' id='LC387'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span class="n">figure</span><span class="p">(</span><span class="n">FigNum</span><span class="o">+</span><span class="mi">1</span><span class="p">),</span>  <span class="n">ncols</span><span class="p">=</span><span class="n">V</span><span class="p">.</span><span class="n">Ncells</span><span class="p">;</span> <span class="n">nrows</span><span class="p">=</span><span class="mi">3</span><span class="p">;</span> <span class="n">END</span><span class="p">=</span><span class="n">V</span><span class="p">.</span><span class="n">T</span><span class="p">;</span> <span class="n">h</span><span class="p">=</span><span class="nb">zeros</span><span class="p">(</span><span class="n">V</span><span class="p">.</span><span class="n">Ncells</span><span class="p">,</span><span class="mi">2</span><span class="p">);</span></div><div class='line' id='LC388'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span class="k">for</span> <span class="nb">j</span><span class="p">=</span><span class="mi">1</span><span class="p">:</span><span class="n">V</span><span class="p">.</span><span class="n">Ncells</span>                                  <span class="c">% plot inferred spike train</span></div><div class='line' id='LC389'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span class="n">h</span><span class="p">(</span><span class="nb">j</span><span class="p">,</span><span class="mi">1</span><span class="p">)=</span><span class="n">subplot</span><span class="p">(</span><span class="n">nrows</span><span class="p">,</span><span class="n">ncols</span><span class="p">,(</span><span class="nb">j</span><span class="o">-</span><span class="mi">1</span><span class="p">)</span><span class="o">*</span><span class="n">ncols</span><span class="o">+</span><span class="mi">1</span><span class="p">);</span> <span class="n">cla</span></div><div class='line' id='LC390'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span class="k">if</span> <span class="n">V</span><span class="p">.</span><span class="n">Npixels</span><span class="o">&gt;</span><span class="mi">1</span><span class="p">,</span> <span class="n">Ftemp</span><span class="p">=</span><span class="n">mean</span><span class="p">(</span><span class="n">F</span><span class="p">);</span> <span class="k">else</span> <span class="n">Ftemp</span><span class="p">=</span><span class="n">F</span><span class="p">;</span> <span class="k">end</span></div><div class='line' id='LC391'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span class="n">plot</span><span class="p">(</span><span class="n">z1</span><span class="p">(</span><span class="n">Ftemp</span><span class="p">(</span><span class="mi">2</span><span class="p">:</span><span class="n">END</span><span class="p">))</span><span class="o">+</span><span class="mi">1</span><span class="p">),</span> <span class="n">hold</span> <span class="n">on</span><span class="p">,</span></div><div class='line' id='LC392'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span class="n">bar</span><span class="p">(</span><span class="n">z1</span><span class="p">(</span><span class="n">n_best</span><span class="p">(</span><span class="mi">2</span><span class="p">:</span><span class="n">END</span><span class="p">,</span><span class="nb">j</span><span class="p">)))</span></div><div class='line' id='LC393'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span class="n">title</span><span class="p">([</span><span class="s">&#39;best iteration &#39;</span> <span class="n">num2str</span><span class="p">(</span><span class="n">i_best</span><span class="p">)]),</span></div><div class='line' id='LC394'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span class="n">axis</span><span class="p">(</span><span class="s">&#39;tight&#39;</span><span class="p">)</span></div><div class='line' id='LC395'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span class="n">set</span><span class="p">(</span><span class="n">gca</span><span class="p">,</span><span class="s">&#39;XTickLabel&#39;</span><span class="p">,[],</span><span class="s">&#39;YTickLabel&#39;</span><span class="p">,[])</span></div><div class='line' id='LC396'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</div><div class='line' id='LC397'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span class="n">h</span><span class="p">(</span><span class="nb">j</span><span class="p">,</span><span class="mi">2</span><span class="p">)=</span><span class="n">subplot</span><span class="p">(</span><span class="n">nrows</span><span class="p">,</span><span class="n">ncols</span><span class="p">,(</span><span class="nb">j</span><span class="o">-</span><span class="mi">1</span><span class="p">)</span><span class="o">*</span><span class="n">ncols</span><span class="o">+</span><span class="mi">2</span><span class="p">);</span> <span class="n">cla</span></div><div class='line' id='LC398'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span class="n">bar</span><span class="p">(</span><span class="n">z1</span><span class="p">(</span><span class="n">n</span><span class="p">(</span><span class="mi">2</span><span class="p">:</span><span class="n">END</span><span class="p">,</span><span class="nb">j</span><span class="p">)))</span></div><div class='line' id='LC399'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span class="k">if</span> <span class="n">isfield</span><span class="p">(</span><span class="n">V</span><span class="p">,</span><span class="s">&#39;n&#39;</span><span class="p">),</span> <span class="n">hold</span> <span class="n">on</span><span class="p">,</span></div><div class='line' id='LC400'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span class="k">for</span> <span class="n">k</span><span class="p">=</span><span class="mi">1</span><span class="p">:</span><span class="n">V</span><span class="p">.</span><span class="n">Ncells</span></div><div class='line' id='LC401'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span class="n">stem</span><span class="p">(</span><span class="n">V</span><span class="p">.</span><span class="n">n</span><span class="p">(</span><span class="mi">2</span><span class="p">:</span><span class="n">END</span><span class="p">,</span><span class="n">k</span><span class="p">)</span><span class="o">+</span><span class="n">k</span><span class="o">/</span><span class="mi">10</span><span class="p">,</span><span class="s">&#39;LineStyle&#39;</span><span class="p">,</span><span class="s">&#39;none&#39;</span><span class="p">,</span><span class="s">&#39;Marker&#39;</span><span class="p">,</span><span class="s">&#39;v&#39;</span><span class="p">,</span><span class="s">&#39;MarkerEdgeColor&#39;</span><span class="p">,</span><span class="s">&#39;k&#39;</span><span class="p">,</span><span class="s">&#39;MarkerFaceColor&#39;</span><span class="p">,</span><span class="s">&#39;k&#39;</span><span class="p">,</span><span class="s">&#39;MarkerSize&#39;</span><span class="p">,</span><span class="mi">2</span><span class="p">)</span></div><div class='line' id='LC402'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span class="k">end</span></div><div class='line' id='LC403'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span class="k">end</span></div><div class='line' id='LC404'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span class="n">set</span><span class="p">(</span><span class="n">gca</span><span class="p">,</span><span class="s">&#39;XTickLabel&#39;</span><span class="p">,[],</span><span class="s">&#39;YTickLabel&#39;</span><span class="p">,[])</span></div><div class='line' id='LC405'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span class="n">title</span><span class="p">([</span><span class="s">&#39;current iteration &#39;</span> <span class="n">num2str</span><span class="p">(</span><span class="nb">i</span><span class="p">)]),</span></div><div class='line' id='LC406'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span class="n">axis</span><span class="p">(</span><span class="s">&#39;tight&#39;</span><span class="p">)</span></div><div class='line' id='LC407'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span class="k">end</span></div><div class='line' id='LC408'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</div><div class='line' id='LC409'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span class="n">subplot</span><span class="p">(</span><span class="n">nrows</span><span class="p">,</span><span class="n">ncols</span><span class="p">,</span><span class="nb">j</span><span class="o">*</span><span class="n">nrows</span><span class="p">),</span></div><div class='line' id='LC410'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span class="n">plot</span><span class="p">(</span><span class="mi">1</span><span class="p">:</span><span class="nb">i</span><span class="p">,</span><span class="n">posts</span><span class="p">(</span><span class="mi">1</span><span class="p">:</span><span class="nb">i</span><span class="p">))</span>    <span class="c">% plot record of likelihoods</span></div><div class='line' id='LC411'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span class="n">title</span><span class="p">([</span><span class="s">&#39;max lik &#39;</span> <span class="n">num2str</span><span class="p">(</span><span class="n">post_max</span><span class="p">,</span><span class="mi">4</span><span class="p">),</span> <span class="s">&#39;,   lik &#39;</span> <span class="n">num2str</span><span class="p">(</span><span class="n">posts</span><span class="p">(</span><span class="nb">i</span><span class="p">),</span><span class="mi">4</span><span class="p">)])</span></div><div class='line' id='LC412'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span class="n">set</span><span class="p">(</span><span class="n">gca</span><span class="p">,</span><span class="s">&#39;XTick&#39;</span><span class="p">,</span><span class="mi">2</span><span class="p">:</span><span class="nb">i</span><span class="p">,</span><span class="s">&#39;XTickLabel&#39;</span><span class="p">,</span><span class="mi">2</span><span class="p">:</span><span class="nb">i</span><span class="p">)</span></div><div class='line' id='LC413'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span class="n">drawnow</span></div><div class='line' id='LC414'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span class="k">end</span></div><div class='line' id='LC415'>&nbsp;&nbsp;&nbsp;&nbsp;<span class="k">end</span></div><div class='line' id='LC416'><span class="k">end</span></div></pre></div></td>
         </tr>
       </table>
  </div>

  </div>
</div>

<a href="#jump-to-line" rel="facebox[.linejump]" data-hotkey="l" class="js-jump-to-line" style="display:none">Jump to Line</a>
<div id="jump-to-line" style="display:none">
  <form accept-charset="UTF-8" class="js-jump-to-line-form">
    <input class="linejump-input js-jump-to-line-field" type="text" placeholder="Jump to line&hellip;" autofocus>
    <button type="submit" class="button">Go</button>
  </form>
</div>

        </div>

      </div><!-- /.repo-container -->
      <div class="modal-backdrop"></div>
    </div><!-- /.container -->
  </div><!-- /.site -->


    </div><!-- /.wrapper -->

      <div class="container">
  <div class="site-footer">
    <ul class="site-footer-links right">
      <li><a href="https://status.github.com/">Status</a></li>
      <li><a href="http://developer.github.com">API</a></li>
      <li><a href="http://training.github.com">Training</a></li>
      <li><a href="http://shop.github.com">Shop</a></li>
      <li><a href="/blog">Blog</a></li>
      <li><a href="/about">About</a></li>

    </ul>

    <a href="/">
      <span class="mega-octicon octicon-mark-github" title="GitHub"></span>
    </a>

    <ul class="site-footer-links">
      <li>&copy; 2014 <span title="0.16215s from github-fe137-cp1-prd.iad.github.net">GitHub</span>, Inc.</li>
        <li><a href="/site/terms">Terms</a></li>
        <li><a href="/site/privacy">Privacy</a></li>
        <li><a href="/security">Security</a></li>
        <li><a href="/contact">Contact</a></li>
    </ul>
  </div><!-- /.site-footer -->
</div><!-- /.container -->


    <div class="fullscreen-overlay js-fullscreen-overlay" id="fullscreen_overlay">
  <div class="fullscreen-container js-fullscreen-container">
    <div class="textarea-wrap">
      <textarea name="fullscreen-contents" id="fullscreen-contents" class="fullscreen-contents js-fullscreen-contents" placeholder="" data-suggester="fullscreen_suggester"></textarea>
    </div>
  </div>
  <div class="fullscreen-sidebar">
    <a href="#" class="exit-fullscreen js-exit-fullscreen tooltipped tooltipped-w" aria-label="Exit Zen Mode">
      <span class="mega-octicon octicon-screen-normal"></span>
    </a>
    <a href="#" class="theme-switcher js-theme-switcher tooltipped tooltipped-w"
      aria-label="Switch themes">
      <span class="octicon octicon-color-mode"></span>
    </a>
  </div>
</div>



    <div id="ajax-error-message" class="flash flash-error">
      <span class="octicon octicon-alert"></span>
      <a href="#" class="octicon octicon-x close js-ajax-error-dismiss"></a>
      Something went wrong with that request. Please try again.
    </div>


      <script crossorigin="anonymous" src="https://assets-cdn.github.com/assets/frameworks-e87aa86ffae369acf33a96bb6567b2b57183be57.js" type="text/javascript"></script>
      <script async="async" crossorigin="anonymous" src="https://assets-cdn.github.com/assets/github-100ee281915e20c71d6b0ff254fbbb70b3fcaf3a.js" type="text/javascript"></script>
      
      
        <script async src="https://www.google-analytics.com/analytics.js"></script>
  </body>
</html>

