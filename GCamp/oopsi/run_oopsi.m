




<!DOCTYPE html>
<html class="   ">
  <head prefix="og: http://ogp.me/ns# fb: http://ogp.me/ns/fb# object: http://ogp.me/ns/object# article: http://ogp.me/ns/article# profile: http://ogp.me/ns/profile#">
    <meta charset='utf-8'>
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    
    
    <title>oopsi/run_oopsi.m at master · jovo/oopsi · GitHub</title>
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

    <meta content="collector.githubapp.com" name="octolytics-host" /><meta content="collector-cdn.github.com" name="octolytics-script-host" /><meta content="github" name="octolytics-app-id" /><meta content="80C551D4:4762:4F5B733:5395B508" name="octolytics-dimension-request_id" />
    

    
    
    <link rel="icon" type="image/x-icon" href="https://assets-cdn.github.com/favicon.ico" />


    <meta content="authenticity_token" name="csrf-param" />
<meta content="6D/80UmZplDicvuZbgkPF7sA85P9T2//dVEeWXb8/qmqXn8Vgc/ONU0qS5dmiMdV9E+WWM8cxLrMQT3YsYxYmQ==" name="csrf-token" />

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
      <a class="button signin" href="/login?return_to=%2Fjovo%2Foopsi%2Fblob%2Fmaster%2Frun_oopsi.m">Sign in</a>
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
          


<a href="/jovo/oopsi/blob/d1931c4faf33728e400112c6516770f530418200/run_oopsi.m" class="hidden js-permalink-shortcut" data-hotkey="y">Permalink</a>

<!-- blob contrib key: blob_contributors:v21:7d1071dbfdbd4380faba9caf196b07b7 -->

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
              <a href="/jovo/oopsi/blob/gh-pages/run_oopsi.m"
                 data-name="gh-pages"
                 data-skip-pjax="true"
                 rel="nofollow"
                 class="js-navigation-open select-menu-item-text js-select-button-text css-truncate-target"
                 title="gh-pages">gh-pages</a>
            </div> <!-- /.select-menu-item -->
            <div class="select-menu-item js-navigation-item selected">
              <span class="select-menu-item-icon octicon octicon-check"></span>
              <a href="/jovo/oopsi/blob/master/run_oopsi.m"
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
              <a href="/jovo/oopsi/tree/v1.0/run_oopsi.m"
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
    <span class='repo-root js-repo-root'><span itemscope="" itemtype="http://data-vocabulary.org/Breadcrumb"><a href="/jovo/oopsi" data-branch="master" data-direction="back" data-pjax="true" itemscope="url"><span itemprop="title">oopsi</span></a></span></span><span class="separator"> / </span><strong class="final-path">run_oopsi.m</strong> <button aria-label="copy to clipboard" class="js-zeroclipboard minibutton zeroclipboard-button" data-clipboard-text="run_oopsi.m" data-copied-hint="copied!" type="button"><span class="octicon octicon-clippy"></span></button>
  </div>
</div>


  <div class="commit commit-loader file-history-tease js-deferred-content" data-url="/jovo/oopsi/contributors/master/run_oopsi.m">
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
          <span>237 lines (214 sloc)</span>
          <span class="meta-divider"></span>
        <span>9.561 kb</span>
      </div>
      <div class="actions">
        <div class="button-group">
            <a class="minibutton tooltipped tooltipped-w"
               href="http://windows.github.com" aria-label="Open this file in GitHub for Windows">
                <span class="octicon octicon-device-desktop"></span> Open
            </a>
              <a class="minibutton disabled tooltipped tooltipped-w" href="#"
                 aria-label="You must be signed in to make or propose changes">Edit</a>
          <a href="/jovo/oopsi/raw/master/run_oopsi.m" class="button minibutton " id="raw-url">Raw</a>
            <a href="/jovo/oopsi/blame/master/run_oopsi.m" class="button minibutton js-update-url-with-hash">Blame</a>
          <a href="/jovo/oopsi/commits/master/run_oopsi.m" class="button minibutton " rel="nofollow">History</a>
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

           </td>
           <td class="blob-line-code"><div class="code-body highlight"><pre><div class='line' id='LC1'><span class="k">function</span><span class="w"> </span>varargout <span class="p">=</span><span class="w"> </span><span class="nf">run_oopsi</span><span class="p">(</span>F,V,P<span class="p">)</span><span class="w"></span></div><div class='line' id='LC2'><span class="c">% this function runs our various oopsi filters, saves the results, and</span></div><div class='line' id='LC3'><span class="c">% plots the inferred spike trains.  make sure that fast-oopsi and</span></div><div class='line' id='LC4'><span class="c">% smc-oopsi repository are in your path if you intend to use them.</span></div><div class='line' id='LC5'><span class="c">%</span></div><div class='line' id='LC6'><span class="c">% to use the code, simply provide F, a vector of fluorescence observations,</span></div><div class='line' id='LC7'><span class="c">% for each cell.  the fast-oopsi code can handle a matrix input,</span></div><div class='line' id='LC8'><span class="c">% corresponding to a set of pixels, for each time bin. smc-oopsi expects a</span></div><div class='line' id='LC9'><span class="c">% 1D fluorescence trace.</span></div><div class='line' id='LC10'><span class="c">%</span></div><div class='line' id='LC11'><span class="c">% see documentation for fast-oopsi and smc-oopsi to determine how to set</span></div><div class='line' id='LC12'><span class="c">% variables</span></div><div class='line' id='LC13'><span class="c">%</span></div><div class='line' id='LC14'><span class="c">% input</span></div><div class='line' id='LC15'><span class="c">%   F: fluorescence from a single neuron</span></div><div class='line' id='LC16'><span class="c">%   V: Variables necessary to define for code to function properly (optional)</span></div><div class='line' id='LC17'><span class="c">%   P: Parameters of the model (optional)</span></div><div class='line' id='LC18'><span class="c">%</span></div><div class='line' id='LC19'><span class="c">% possible outputs</span></div><div class='line' id='LC20'><span class="c">%   fast:   fast-oopsi MAP estimate of spike train, argmax_{n\geq 0} P[n|F], (fast.n),  parameter estimate (fast.P), and structure of  variables for algorithm (fast.V)</span></div><div class='line' id='LC21'><span class="c">%   smc:    smc-oopsi estimate of {P[X_t|F]}_{t&lt;T}, where X={n,C} or {n,C,h}, (smc.E), parameter estimates (smc.P), and structure of variables for algorithm (fast.V)</span></div><div class='line' id='LC22'><br/></div><div class='line' id='LC23'><span class="c">%% set code Variables</span></div><div class='line' id='LC24'><br/></div><div class='line' id='LC25'><span class="k">if</span> <span class="n">nargin</span> <span class="o">&lt;</span> <span class="mi">2</span><span class="p">,</span> <span class="n">V</span> <span class="p">=</span> <span class="n">struct</span><span class="p">;</span>   <span class="k">end</span>         <span class="c">% create structure for algorithmic variables, if none provided</span></div><div class='line' id='LC26'><span class="k">if</span> <span class="o">~</span><span class="n">isfield</span><span class="p">(</span><span class="n">V</span><span class="p">,</span><span class="s">&#39;fast_iter_max&#39;</span><span class="p">)</span></div><div class='line' id='LC27'>&nbsp;&nbsp;&nbsp;&nbsp;<span class="n">V</span><span class="p">.</span><span class="n">fast_iter_max</span> <span class="p">=</span> <span class="n">input</span><span class="p">(</span><span class="s">&#39;\nhow many iterations of fast-oopsi would you like to do [0,1,2,...]: &#39;</span><span class="p">);</span></div><div class='line' id='LC28'><span class="k">end</span></div><div class='line' id='LC29'><span class="k">if</span> <span class="o">~</span><span class="n">isfield</span><span class="p">(</span><span class="n">V</span><span class="p">,</span><span class="s">&#39;smc_iter_max&#39;</span><span class="p">)</span></div><div class='line' id='LC30'>&nbsp;&nbsp;&nbsp;&nbsp;<span class="n">V</span><span class="p">.</span><span class="n">smc_iter_max</span> <span class="p">=</span> <span class="n">input</span><span class="p">(</span><span class="s">&#39;\how many iterations of smc-oopsi would you like to do [0,1,2,...]: &#39;</span><span class="p">);</span></div><div class='line' id='LC31'><span class="k">end</span></div><div class='line' id='LC32'><br/></div><div class='line' id='LC33'><span class="k">if</span> <span class="o">~</span><span class="n">isfield</span><span class="p">(</span><span class="n">V</span><span class="p">,</span><span class="s">&#39;dt&#39;</span><span class="p">),</span>                                    <span class="c">% frame duration</span></div><div class='line' id='LC34'>&nbsp;&nbsp;&nbsp;&nbsp;<span class="n">fr</span> <span class="p">=</span> <span class="n">input</span><span class="p">(</span><span class="s">&#39;\nwhat was the frame rate for this movie (in Hz)?: &#39;</span><span class="p">);</span></div><div class='line' id='LC35'>&nbsp;&nbsp;&nbsp;&nbsp;<span class="n">V</span><span class="p">.</span><span class="n">dt</span> <span class="p">=</span> <span class="mi">1</span><span class="o">/</span><span class="n">fr</span><span class="p">;</span></div><div class='line' id='LC36'><span class="k">end</span></div><div class='line' id='LC37'><br/></div><div class='line' id='LC38'><span class="k">if</span> <span class="o">~</span><span class="n">isfield</span><span class="p">(</span><span class="n">V</span><span class="p">,</span><span class="s">&#39;preprocess&#39;</span><span class="p">),</span></div><div class='line' id='LC39'>&nbsp;&nbsp;&nbsp;&nbsp;<span class="n">V</span><span class="p">.</span><span class="n">preprocess</span> <span class="p">=</span> <span class="n">input</span><span class="p">(</span><span class="s">&#39;\ndo you want to high-pass filter [0=no, 1=yes]?: &#39;</span><span class="p">);</span></div><div class='line' id='LC40'><span class="k">end</span></div><div class='line' id='LC41'><br/></div><div class='line' id='LC42'><span class="k">if</span> <span class="o">~</span><span class="n">isfield</span><span class="p">(</span><span class="n">V</span><span class="p">,</span><span class="s">&#39;n_max&#39;</span><span class="p">),</span>     <span class="n">V</span><span class="p">.</span><span class="n">n_max</span>     <span class="p">=</span> <span class="mi">2</span><span class="p">;</span>        <span class="k">end</span></div><div class='line' id='LC43'><span class="k">if</span> <span class="n">nargin</span> <span class="o">&lt;</span> <span class="mi">3</span><span class="p">,</span>              <span class="n">P</span>           <span class="p">=</span> <span class="n">struct</span><span class="p">;</span>   <span class="k">end</span>         <span class="c">% create structure for parameters, if none provided</span></div><div class='line' id='LC44'><span class="k">if</span> <span class="o">~</span><span class="n">isfield</span><span class="p">(</span><span class="n">V</span><span class="p">,</span><span class="s">&#39;plot&#39;</span><span class="p">),</span>      <span class="n">V</span><span class="p">.</span><span class="n">plot</span>      <span class="p">=</span> <span class="mi">1</span><span class="p">;</span>        <span class="k">end</span>         <span class="c">% whether to plot the fluorescence and spike trains</span></div><div class='line' id='LC45'><span class="k">if</span> <span class="o">~</span><span class="n">isfield</span><span class="p">(</span><span class="n">V</span><span class="p">,</span><span class="s">&#39;name&#39;</span><span class="p">),</span>                                          <span class="c">% give data a unique, time-stamped name, if there is not one specified</span></div><div class='line' id='LC46'>&nbsp;&nbsp;&nbsp;&nbsp;<span class="n">lic</span>     <span class="p">=</span> <span class="n">str2num</span><span class="p">(</span><span class="n">license</span><span class="p">);</span>                                 <span class="c">% jovo&#39;s license #</span></div><div class='line' id='LC47'>&nbsp;&nbsp;&nbsp;&nbsp;<span class="k">if</span> <span class="n">lic</span> <span class="o">==</span> <span class="mi">273165</span><span class="p">,</span>                                           <span class="c">% if using jovo&#39;s computer, set data and fig folders</span></div><div class='line' id='LC48'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span class="n">fdat</span> <span class="p">=</span> <span class="s">&#39;~/Research/oopsi/meta-oopsi/data/jovo&#39;</span><span class="p">;</span></div><div class='line' id='LC49'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span class="n">ffig</span> <span class="p">=</span> <span class="s">&#39;~/Research/oopsi/meta-oopsi/figs/jovo&#39;</span><span class="p">;</span></div><div class='line' id='LC50'>&nbsp;&nbsp;&nbsp;&nbsp;<span class="k">else</span>                                                        <span class="c">% else just use current dir</span></div><div class='line' id='LC51'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span class="n">fdat</span> <span class="p">=</span> <span class="n">pwd</span><span class="p">;</span></div><div class='line' id='LC52'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span class="n">ffig</span> <span class="p">=</span> <span class="n">pwd</span><span class="p">;</span></div><div class='line' id='LC53'>&nbsp;&nbsp;&nbsp;&nbsp;<span class="k">end</span></div><div class='line' id='LC54'>&nbsp;&nbsp;&nbsp;&nbsp;<span class="n">V</span><span class="p">.</span><span class="n">name</span>  <span class="p">=</span> <span class="p">[</span><span class="s">&#39;/oopsi_&#39;</span> <span class="n">datestr</span><span class="p">(</span><span class="n">clock</span><span class="p">,</span><span class="mi">30</span><span class="p">)];</span></div><div class='line' id='LC55'><span class="k">else</span></div><div class='line' id='LC56'>&nbsp;&nbsp;&nbsp;&nbsp;<span class="n">fdat</span> <span class="p">=</span> <span class="n">pwd</span><span class="p">;</span></div><div class='line' id='LC57'>&nbsp;&nbsp;&nbsp;&nbsp;<span class="n">ffig</span> <span class="p">=</span> <span class="n">pwd</span><span class="p">;</span></div><div class='line' id='LC58'><span class="k">end</span></div><div class='line' id='LC59'><br/></div><div class='line' id='LC60'><span class="k">if</span> <span class="o">~</span><span class="n">isfield</span><span class="p">(</span><span class="n">V</span><span class="p">,</span><span class="s">&#39;save&#39;</span><span class="p">),</span>      <span class="n">V</span><span class="p">.</span><span class="n">save</span>      <span class="p">=</span> <span class="mi">0</span><span class="p">;</span>        <span class="k">end</span>         <span class="c">% whether to save results and figs</span></div><div class='line' id='LC61'><span class="k">if</span> <span class="n">V</span><span class="p">.</span><span class="n">save</span> <span class="o">==</span> <span class="mi">1</span></div><div class='line' id='LC62'>&nbsp;&nbsp;&nbsp;&nbsp;<span class="k">if</span> <span class="n">isfield</span><span class="p">(</span><span class="n">V</span><span class="p">,</span><span class="s">&#39;dat_dir&#39;</span><span class="p">),</span> <span class="n">fdat</span><span class="p">=</span><span class="n">V</span><span class="p">.</span><span class="n">dat_dir</span><span class="p">;</span> <span class="k">end</span></div><div class='line' id='LC63'>&nbsp;&nbsp;&nbsp;&nbsp;<span class="n">V</span><span class="p">.</span><span class="n">name_dat</span> <span class="p">=</span> <span class="p">[</span><span class="n">fdat</span> <span class="n">V</span><span class="p">.</span><span class="n">name</span><span class="p">];</span>                                 <span class="c">% filename for data</span></div><div class='line' id='LC64'>&nbsp;&nbsp;&nbsp;&nbsp;<span class="n">save</span><span class="p">(</span><span class="n">V</span><span class="p">.</span><span class="n">name_dat</span><span class="p">,</span><span class="s">&#39;V&#39;</span><span class="p">)</span></div><div class='line' id='LC65'><span class="k">end</span></div><div class='line' id='LC66'><br/></div><div class='line' id='LC67'><span class="c">%% preprocess - remove the lowest 10 frequencies</span></div><div class='line' id='LC68'><br/></div><div class='line' id='LC69'><span class="k">if</span> <span class="n">V</span><span class="p">.</span><span class="n">preprocess</span><span class="o">==</span><span class="mi">1</span></div><div class='line' id='LC70'>&nbsp;&nbsp;&nbsp;&nbsp;<span class="n">V</span><span class="p">.</span><span class="n">T</span>     <span class="p">=</span> <span class="nb">length</span><span class="p">(</span><span class="n">F</span><span class="p">);</span></div><div class='line' id='LC71'>&nbsp;&nbsp;&nbsp;&nbsp;<span class="n">f</span>       <span class="p">=</span> <span class="n">detrend</span><span class="p">(</span><span class="n">F</span><span class="p">);</span></div><div class='line' id='LC72'>&nbsp;&nbsp;&nbsp;&nbsp;<span class="n">nfft</span>    <span class="p">=</span> <span class="mi">2</span>^<span class="nb">nextpow2</span><span class="p">(</span><span class="n">V</span><span class="p">.</span><span class="n">T</span><span class="p">);</span></div><div class='line' id='LC73'>&nbsp;&nbsp;&nbsp;&nbsp;<span class="n">y</span>       <span class="p">=</span> <span class="n">fft</span><span class="p">(</span><span class="n">f</span><span class="p">,</span><span class="n">nfft</span><span class="p">);</span></div><div class='line' id='LC74'>&nbsp;&nbsp;&nbsp;&nbsp;<span class="n">bw</span>      <span class="p">=</span> <span class="mi">3</span><span class="p">;</span></div><div class='line' id='LC75'>&nbsp;&nbsp;&nbsp;&nbsp;<span class="n">y</span><span class="p">(</span><span class="mi">1</span><span class="p">:</span><span class="n">bw</span><span class="p">)</span> <span class="p">=</span> <span class="mi">0</span><span class="p">;</span> <span class="n">y</span><span class="p">(</span><span class="k">end</span><span class="o">-</span><span class="n">bw</span><span class="o">+</span><span class="mi">1</span><span class="p">:</span><span class="k">end</span><span class="p">)=</span><span class="mi">0</span><span class="p">;</span></div><div class='line' id='LC76'>&nbsp;&nbsp;&nbsp;&nbsp;<span class="n">iy</span>      <span class="p">=</span> <span class="n">ifft</span><span class="p">(</span><span class="n">y</span><span class="p">,</span><span class="n">nfft</span><span class="p">);</span></div><div class='line' id='LC77'>&nbsp;&nbsp;&nbsp;&nbsp;<span class="n">F</span>       <span class="p">=</span> <span class="n">z1</span><span class="p">(</span><span class="nb">real</span><span class="p">(</span><span class="n">iy</span><span class="p">(</span><span class="mi">1</span><span class="p">:</span><span class="n">V</span><span class="p">.</span><span class="n">T</span><span class="p">)));</span></div><div class='line' id='LC78'><span class="k">end</span></div><div class='line' id='LC79'><br/></div><div class='line' id='LC80'><span class="c">%% infer spikes and estimate parameters</span></div><div class='line' id='LC81'><br/></div><div class='line' id='LC82'><span class="c">% infer spikes using fast-oopsi</span></div><div class='line' id='LC83'><span class="k">if</span> <span class="n">V</span><span class="p">.</span><span class="n">fast_iter_max</span> <span class="o">&gt;</span> <span class="mi">0</span></div><div class='line' id='LC84'>&nbsp;&nbsp;&nbsp;&nbsp;<span class="n">fprintf</span><span class="p">(</span><span class="s">&#39;\nfast-oopsi\n&#39;</span><span class="p">)</span></div><div class='line' id='LC85'>&nbsp;&nbsp;&nbsp;&nbsp;<span class="p">[</span><span class="n">fast</span><span class="p">.</span><span class="n">n</span> <span class="n">fast</span><span class="p">.</span><span class="n">P</span> <span class="n">fast</span><span class="p">.</span><span class="n">V</span><span class="p">]=</span> <span class="n">fast_oopsi</span><span class="p">(</span><span class="n">F</span><span class="p">,</span><span class="n">V</span><span class="p">,</span><span class="n">P</span><span class="p">);</span></div><div class='line' id='LC86'>&nbsp;&nbsp;&nbsp;&nbsp;<span class="k">if</span> <span class="n">V</span><span class="p">.</span><span class="n">save</span><span class="p">,</span> <span class="n">save</span><span class="p">(</span><span class="n">V</span><span class="p">.</span><span class="n">name_dat</span><span class="p">,</span><span class="s">&#39;fast&#39;</span><span class="p">,</span><span class="s">&#39;-append&#39;</span><span class="p">);</span> <span class="k">end</span></div><div class='line' id='LC87'><span class="k">end</span></div><div class='line' id='LC88'><br/></div><div class='line' id='LC89'><span class="n">stupid</span><span class="p">=</span><span class="mi">1</span><span class="p">;</span></div><div class='line' id='LC90'><span class="c">% infer spikes using smc-oopsi</span></div><div class='line' id='LC91'><span class="k">if</span> <span class="n">V</span><span class="p">.</span><span class="n">smc_iter_max</span> <span class="o">&gt;</span> <span class="mi">0</span></div><div class='line' id='LC92'>&nbsp;&nbsp;&nbsp;&nbsp;<span class="n">fprintf</span><span class="p">(</span><span class="s">&#39;\nsmc-oopsi\n&#39;</span><span class="p">)</span></div><div class='line' id='LC93'>&nbsp;&nbsp;&nbsp;&nbsp;<span class="n">siz</span><span class="p">=</span><span class="nb">size</span><span class="p">(</span><span class="n">F</span><span class="p">);</span> <span class="k">if</span> <span class="n">siz</span><span class="p">(</span><span class="mi">1</span><span class="p">)</span><span class="o">&gt;</span><span class="mi">1</span><span class="p">,</span> <span class="n">F</span><span class="p">=</span><span class="n">F</span><span class="o">&#39;</span><span class="p">;</span> <span class="k">end</span></div><div class='line' id='LC94'>&nbsp;&nbsp;&nbsp;&nbsp;<span class="k">if</span> <span class="n">V</span><span class="p">.</span><span class="n">fast_iter_max</span> <span class="o">&gt;</span> <span class="mi">0</span><span class="p">;</span></div><div class='line' id='LC95'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span class="k">if</span> <span class="o">~</span><span class="n">isfield</span><span class="p">(</span><span class="n">P</span><span class="p">,</span><span class="s">&#39;A&#39;</span><span class="p">),</span>     <span class="n">P</span><span class="p">.</span><span class="n">A</span>     <span class="p">=</span> <span class="mi">50</span><span class="p">;</span>   <span class="k">end</span>             <span class="c">% initialize jump in [Ca++] after spike</span></div><div class='line' id='LC96'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span class="k">if</span> <span class="o">~</span><span class="n">isfield</span><span class="p">(</span><span class="n">P</span><span class="p">,</span><span class="s">&#39;n&#39;</span><span class="p">),</span>     <span class="n">P</span><span class="p">.</span><span class="n">n</span>     <span class="p">=</span> <span class="mi">1</span><span class="p">;</span>    <span class="k">end</span>             <span class="c">% Hill coefficient</span></div><div class='line' id='LC97'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span class="k">if</span> <span class="o">~</span><span class="n">isfield</span><span class="p">(</span><span class="n">P</span><span class="p">,</span><span class="s">&#39;k_d&#39;</span><span class="p">),</span>   <span class="n">P</span><span class="p">.</span><span class="n">k_d</span>   <span class="p">=</span> <span class="mi">200</span><span class="p">;</span>  <span class="k">end</span>             <span class="c">% dissociation constant</span></div><div class='line' id='LC98'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span class="k">if</span> <span class="o">~</span><span class="n">isfield</span><span class="p">(</span><span class="n">V</span><span class="p">,</span><span class="s">&#39;T&#39;</span><span class="p">),</span>     <span class="n">V</span><span class="p">.</span><span class="n">T</span>     <span class="p">=</span> <span class="n">fast</span><span class="p">.</span><span class="n">V</span><span class="p">.</span><span class="n">T</span><span class="p">;</span> <span class="k">end</span>         <span class="c">% number of time steps</span></div><div class='line' id='LC99'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span class="k">if</span> <span class="o">~</span><span class="n">isfield</span><span class="p">(</span><span class="n">V</span><span class="p">,</span><span class="s">&#39;dt&#39;</span><span class="p">),</span>    <span class="n">V</span><span class="p">.</span><span class="n">dt</span>    <span class="p">=</span> <span class="n">fast</span><span class="p">.</span><span class="n">V</span><span class="p">.</span><span class="n">dt</span><span class="p">;</span> <span class="k">end</span>        <span class="c">% frame duration, aka, 1/(framte rate)</span></div><div class='line' id='LC100'><br/></div><div class='line' id='LC101'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span class="k">if</span> <span class="o">~</span><span class="n">exist</span><span class="p">(</span><span class="s">&#39;stupid&#39;</span><span class="p">)</span></div><div class='line' id='LC102'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span class="n">bign1</span><span class="p">=</span><span class="nb">find</span><span class="p">(</span><span class="n">fast</span><span class="p">.</span><span class="n">n</span><span class="o">&gt;</span><span class="mf">0.1</span><span class="p">);</span></div><div class='line' id='LC103'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span class="n">bign0</span><span class="p">=</span><span class="n">bign1</span><span class="o">-</span><span class="mi">1</span><span class="p">;</span></div><div class='line' id='LC104'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span class="n">df</span><span class="p">=</span><span class="n">max</span><span class="p">((</span><span class="n">F</span><span class="p">(</span><span class="n">bign1</span><span class="p">)</span><span class="o">-</span><span class="n">F</span><span class="p">(</span><span class="n">bign0</span><span class="p">))</span><span class="o">./</span><span class="p">(</span><span class="n">F</span><span class="p">(</span><span class="n">bign0</span><span class="p">)));</span></div><div class='line' id='LC105'><br/></div><div class='line' id='LC106'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span class="n">P</span><span class="p">.</span><span class="n">C_init</span><span class="p">=</span> <span class="n">P</span><span class="p">.</span><span class="n">C_0</span><span class="p">;</span></div><div class='line' id='LC107'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span class="n">S0</span>      <span class="p">=</span> <span class="n">Hill_v1</span><span class="p">(</span><span class="n">P</span><span class="p">,</span><span class="n">P</span><span class="p">.</span><span class="n">C_0</span><span class="p">);</span></div><div class='line' id='LC108'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span class="n">arg</span>     <span class="p">=</span> <span class="n">S0</span> <span class="o">+</span> <span class="n">df</span><span class="o">*</span><span class="p">(</span><span class="n">S0</span> <span class="o">+</span> <span class="mi">1</span><span class="o">/</span><span class="mi">13</span><span class="p">);</span></div><div class='line' id='LC109'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span class="n">P</span><span class="p">.</span><span class="n">A</span>     <span class="p">=</span> <span class="p">((</span><span class="n">arg</span><span class="o">*</span><span class="n">P</span><span class="p">.</span><span class="n">k_d</span><span class="p">)</span><span class="o">./</span><span class="p">(</span><span class="mi">1</span><span class="o">-</span><span class="n">arg</span><span class="p">))</span><span class="o">.^</span><span class="p">(</span><span class="mi">1</span><span class="o">/</span><span class="n">P</span><span class="p">.</span><span class="n">n</span><span class="p">)</span><span class="o">-</span><span class="n">P</span><span class="p">.</span><span class="n">C_0</span><span class="p">;</span></div><div class='line' id='LC110'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span class="k">end</span></div><div class='line' id='LC111'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span class="n">P</span><span class="p">.</span><span class="n">C_0</span>   <span class="p">=</span> <span class="mi">0</span><span class="p">;</span></div><div class='line' id='LC112'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span class="n">P</span><span class="p">.</span><span class="n">tau_c</span> <span class="p">=</span> <span class="n">fast</span><span class="p">.</span><span class="n">V</span><span class="p">.</span><span class="n">dt</span><span class="o">/</span><span class="p">(</span><span class="mi">1</span><span class="o">-</span><span class="n">fast</span><span class="p">.</span><span class="n">P</span><span class="p">.</span><span class="n">gam</span><span class="p">);</span>                     <span class="c">% time constant</span></div><div class='line' id='LC113'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span class="n">nnorm</span>   <span class="p">=</span> <span class="n">V</span><span class="p">.</span><span class="n">n_max</span><span class="o">*</span><span class="n">fast</span><span class="p">.</span><span class="n">n</span><span class="o">/</span><span class="n">max</span><span class="p">(</span><span class="n">fast</span><span class="p">.</span><span class="n">n</span><span class="p">);</span>                           <span class="c">% normalize inferred spike train</span></div><div class='line' id='LC114'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span class="n">C</span>       <span class="p">=</span> <span class="n">filter</span><span class="p">(</span><span class="mi">1</span><span class="p">,[</span><span class="mi">1</span> <span class="o">-</span><span class="n">fast</span><span class="p">.</span><span class="n">P</span><span class="p">.</span><span class="n">gam</span><span class="p">],</span><span class="n">P</span><span class="p">.</span><span class="n">A</span><span class="o">*</span><span class="n">nnorm</span><span class="p">)</span><span class="o">&#39;+</span><span class="n">P</span><span class="p">.</span><span class="n">C_0</span><span class="p">;</span>         <span class="c">% calcium concentration</span></div><div class='line' id='LC115'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span class="n">C1</span>      <span class="p">=</span> <span class="p">[</span><span class="n">Hill_v1</span><span class="p">(</span><span class="n">P</span><span class="p">,</span><span class="n">C</span><span class="p">);</span> <span class="nb">ones</span><span class="p">(</span><span class="mi">1</span><span class="p">,</span><span class="n">V</span><span class="p">.</span><span class="n">T</span><span class="p">)];</span>                  <span class="c">% for brevity</span></div><div class='line' id='LC116'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span class="n">ab</span>      <span class="p">=</span> <span class="n">C1</span><span class="o">&#39;\</span><span class="n">F</span><span class="o">&#39;</span><span class="p">;</span>                                       <span class="c">% estimate scalse and offset</span></div><div class='line' id='LC117'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span class="n">P</span><span class="p">.</span><span class="n">alpha</span> <span class="p">=</span> <span class="n">ab</span><span class="p">(</span><span class="mi">1</span><span class="p">);</span>                                        <span class="c">% fluorescence scale</span></div><div class='line' id='LC118'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span class="n">P</span><span class="p">.</span><span class="nb">beta</span>  <span class="p">=</span> <span class="n">ab</span><span class="p">(</span><span class="mi">2</span><span class="p">);</span>                                        <span class="c">% fluorescence offset</span></div><div class='line' id='LC119'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span class="n">P</span><span class="p">.</span><span class="n">zeta</span>  <span class="p">=</span> <span class="p">(</span><span class="n">mad</span><span class="p">(</span><span class="n">F</span><span class="o">-</span><span class="n">ab</span><span class="o">&#39;*</span><span class="n">C1</span><span class="p">,</span><span class="mi">1</span><span class="p">)</span><span class="o">*</span><span class="mf">1.4785</span><span class="p">)</span>^<span class="mi">2</span><span class="p">;</span></div><div class='line' id='LC120'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span class="n">P</span><span class="p">.</span><span class="nb">gamma</span> <span class="p">=</span> <span class="n">P</span><span class="p">.</span><span class="n">zeta</span><span class="o">/</span><span class="mi">5</span><span class="p">;</span>                                     <span class="c">% signal dependent noise</span></div><div class='line' id='LC121'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span class="n">P</span><span class="p">.</span><span class="n">k</span> <span class="p">=</span> <span class="n">V</span><span class="p">.</span><span class="n">spikegen</span><span class="p">.</span><span class="n">EFGinv</span><span class="p">(</span><span class="mf">0.01</span><span class="p">,</span> <span class="n">P</span><span class="p">,</span> <span class="n">V</span><span class="p">);</span></div><div class='line' id='LC122'><br/></div><div class='line' id='LC123'>&nbsp;&nbsp;&nbsp;&nbsp;<span class="k">end</span></div><div class='line' id='LC124'>&nbsp;&nbsp;&nbsp;&nbsp;<span class="p">[</span><span class="n">smc</span><span class="p">.</span><span class="n">E</span> <span class="n">smc</span><span class="p">.</span><span class="n">P</span> <span class="n">smc</span><span class="p">.</span><span class="n">V</span><span class="p">]</span> <span class="p">=</span> <span class="n">smc_oopsi</span><span class="p">(</span><span class="n">F</span><span class="p">,</span><span class="n">V</span><span class="p">,</span><span class="n">P</span><span class="p">);</span></div><div class='line' id='LC125'>&nbsp;&nbsp;&nbsp;&nbsp;<span class="k">if</span> <span class="n">V</span><span class="p">.</span><span class="n">save</span><span class="p">,</span> <span class="n">save</span><span class="p">(</span><span class="n">V</span><span class="p">.</span><span class="n">name_dat</span><span class="p">,</span><span class="s">&#39;smc&#39;</span><span class="p">,</span><span class="s">&#39;-append&#39;</span><span class="p">);</span> <span class="k">end</span></div><div class='line' id='LC126'><span class="k">end</span></div><div class='line' id='LC127'><br/></div><div class='line' id='LC128'><span class="c">%% provide outputs for later analysis</span></div><div class='line' id='LC129'><br/></div><div class='line' id='LC130'><span class="k">if</span> <span class="n">nargout</span> <span class="o">==</span> <span class="mi">1</span></div><div class='line' id='LC131'>&nbsp;&nbsp;&nbsp;&nbsp;<span class="k">if</span> <span class="n">V</span><span class="p">.</span><span class="n">fast_iter_max</span> <span class="o">&gt;</span> <span class="mi">0</span></div><div class='line' id='LC132'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span class="n">varargout</span><span class="p">{</span><span class="mi">1</span><span class="p">}</span> <span class="p">=</span> <span class="n">fast</span><span class="p">;</span></div><div class='line' id='LC133'>&nbsp;&nbsp;&nbsp;&nbsp;<span class="k">else</span></div><div class='line' id='LC134'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span class="n">varargout</span><span class="p">{</span><span class="mi">1</span><span class="p">}</span> <span class="p">=</span> <span class="n">smc</span><span class="p">;</span></div><div class='line' id='LC135'>&nbsp;&nbsp;&nbsp;&nbsp;<span class="k">end</span></div><div class='line' id='LC136'><span class="k">elseif</span> <span class="n">nargout</span> <span class="o">==</span> <span class="mi">2</span></div><div class='line' id='LC137'>&nbsp;&nbsp;&nbsp;&nbsp;<span class="k">if</span> <span class="n">V</span><span class="p">.</span><span class="n">fast_iter_max</span><span class="o">&gt;</span><span class="mi">0</span> <span class="o">&amp;&amp;</span> <span class="n">V</span><span class="p">.</span><span class="n">smc_iter_max</span><span class="o">&gt;</span><span class="mi">0</span></div><div class='line' id='LC138'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span class="n">varargout</span><span class="p">{</span><span class="mi">1</span><span class="p">}</span> <span class="p">=</span> <span class="n">fast</span><span class="p">;</span></div><div class='line' id='LC139'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span class="n">varargout</span><span class="p">{</span><span class="mi">2</span><span class="p">}</span> <span class="p">=</span> <span class="n">smc</span><span class="p">;</span></div><div class='line' id='LC140'>&nbsp;&nbsp;&nbsp;&nbsp;<span class="k">else</span></div><div class='line' id='LC141'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span class="k">if</span> <span class="n">V</span><span class="p">.</span><span class="n">fast_iter_max</span><span class="o">&gt;</span><span class="mi">0</span></div><div class='line' id='LC142'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span class="n">varargout</span><span class="p">{</span><span class="mi">1</span><span class="p">}</span> <span class="p">=</span> <span class="n">fast</span><span class="p">;</span></div><div class='line' id='LC143'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span class="n">varargout</span><span class="p">{</span><span class="mi">2</span><span class="p">}</span> <span class="p">=</span> <span class="n">V</span><span class="p">;</span></div><div class='line' id='LC144'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span class="k">else</span></div><div class='line' id='LC145'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span class="n">varargout</span><span class="p">{</span><span class="mi">1</span><span class="p">}</span>  <span class="p">=</span> <span class="n">smc</span><span class="p">;</span></div><div class='line' id='LC146'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span class="n">varargout</span><span class="p">{</span><span class="mi">2</span><span class="p">}</span> <span class="p">=</span> <span class="n">V</span><span class="p">;</span></div><div class='line' id='LC147'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span class="k">end</span></div><div class='line' id='LC148'>&nbsp;&nbsp;&nbsp;&nbsp;<span class="k">end</span></div><div class='line' id='LC149'><span class="k">elseif</span> <span class="n">nargout</span> <span class="o">==</span> <span class="mi">3</span></div><div class='line' id='LC150'>&nbsp;&nbsp;&nbsp;&nbsp;<span class="n">varargout</span><span class="p">{</span><span class="mi">1</span><span class="p">}</span> <span class="p">=</span> <span class="n">fast</span><span class="p">;</span></div><div class='line' id='LC151'>&nbsp;&nbsp;&nbsp;&nbsp;<span class="n">varargout</span><span class="p">{</span><span class="mi">2</span><span class="p">}</span> <span class="p">=</span> <span class="n">smc</span><span class="p">;</span></div><div class='line' id='LC152'>&nbsp;&nbsp;&nbsp;&nbsp;<span class="n">varargout</span><span class="p">{</span><span class="mi">3</span><span class="p">}</span> <span class="p">=</span> <span class="n">V</span><span class="p">;</span></div><div class='line' id='LC153'><span class="k">end</span></div><div class='line' id='LC154'><br/></div><div class='line' id='LC155'><span class="c">%% plot results</span></div><div class='line' id='LC156'><br/></div><div class='line' id='LC157'><span class="k">if</span> <span class="n">V</span><span class="p">.</span><span class="n">plot</span></div><div class='line' id='LC158'>&nbsp;&nbsp;&nbsp;&nbsp;<span class="k">if</span> <span class="n">isfield</span><span class="p">(</span><span class="n">V</span><span class="p">,</span><span class="s">&#39;fig_dir&#39;</span><span class="p">),</span> <span class="n">ffig</span><span class="p">=</span><span class="n">V</span><span class="p">.</span><span class="n">fig_dir</span><span class="p">;</span> <span class="k">end</span></div><div class='line' id='LC159'>&nbsp;&nbsp;&nbsp;&nbsp;<span class="n">V</span><span class="p">.</span><span class="n">name_fig</span> <span class="p">=</span> <span class="p">[</span><span class="n">ffig</span> <span class="n">V</span><span class="p">.</span><span class="n">name</span><span class="p">];</span>                                 <span class="c">% filename for figure</span></div><div class='line' id='LC160'>&nbsp;&nbsp;&nbsp;&nbsp;<span class="n">fig</span> <span class="p">=</span> <span class="n">figure</span><span class="p">(</span><span class="mi">3</span><span class="p">);</span></div><div class='line' id='LC161'>&nbsp;&nbsp;&nbsp;&nbsp;<span class="n">clf</span><span class="p">,</span></div><div class='line' id='LC162'>&nbsp;&nbsp;&nbsp;&nbsp;<span class="n">V</span><span class="p">.</span><span class="n">T</span>     <span class="p">=</span> <span class="nb">length</span><span class="p">(</span><span class="n">F</span><span class="p">);</span></div><div class='line' id='LC163'>&nbsp;&nbsp;&nbsp;&nbsp;<span class="n">nrows</span>   <span class="p">=</span> <span class="mi">1</span><span class="p">;</span></div><div class='line' id='LC164'>&nbsp;&nbsp;&nbsp;&nbsp;<span class="k">if</span> <span class="n">V</span><span class="p">.</span><span class="n">fast_iter_max</span><span class="o">&gt;</span><span class="mi">0</span><span class="p">,</span>    <span class="n">nrows</span><span class="p">=</span><span class="n">nrows</span><span class="o">+</span><span class="mi">1</span><span class="p">;</span> <span class="k">end</span></div><div class='line' id='LC165'>&nbsp;&nbsp;&nbsp;&nbsp;<span class="k">if</span> <span class="n">V</span><span class="p">.</span><span class="n">smc_iter_max</span><span class="o">&gt;</span><span class="mi">0</span><span class="p">,</span>     <span class="n">nrows</span><span class="p">=</span><span class="n">nrows</span><span class="o">+</span><span class="mi">1</span><span class="p">;</span> <span class="k">end</span></div><div class='line' id='LC166'>&nbsp;&nbsp;&nbsp;&nbsp;<span class="n">gray</span>    <span class="p">=</span> <span class="p">[.</span><span class="mi">75</span> <span class="p">.</span><span class="mi">75</span> <span class="p">.</span><span class="mi">75</span><span class="p">];</span>            <span class="c">% define gray color</span></div><div class='line' id='LC167'>&nbsp;&nbsp;&nbsp;&nbsp;<span class="n">inter</span>   <span class="p">=</span> <span class="s">&#39;tex&#39;</span><span class="p">;</span>                    <span class="c">% interpreter for axis labels</span></div><div class='line' id='LC168'>&nbsp;&nbsp;&nbsp;&nbsp;<span class="n">xlims</span>   <span class="p">=</span> <span class="p">[</span><span class="mi">1</span> <span class="n">V</span><span class="p">.</span><span class="n">T</span><span class="p">];</span>               <span class="c">% xmin and xmax for current plot</span></div><div class='line' id='LC169'>&nbsp;&nbsp;&nbsp;&nbsp;<span class="n">fs</span>      <span class="p">=</span> <span class="mi">12</span><span class="p">;</span>                       <span class="c">% font size</span></div><div class='line' id='LC170'>&nbsp;&nbsp;&nbsp;&nbsp;<span class="n">ms</span>      <span class="p">=</span> <span class="mi">5</span><span class="p">;</span>                        <span class="c">% marker size for real spike</span></div><div class='line' id='LC171'>&nbsp;&nbsp;&nbsp;&nbsp;<span class="n">sw</span>      <span class="p">=</span> <span class="mi">2</span><span class="p">;</span>                        <span class="c">% spike width</span></div><div class='line' id='LC172'>&nbsp;&nbsp;&nbsp;&nbsp;<span class="n">lw</span>      <span class="p">=</span> <span class="mi">1</span><span class="p">;</span>                        <span class="c">% line width</span></div><div class='line' id='LC173'>&nbsp;&nbsp;&nbsp;&nbsp;<span class="n">xticks</span>  <span class="p">=</span> <span class="mi">0</span><span class="p">:</span><span class="mi">1</span><span class="o">/</span><span class="n">V</span><span class="p">.</span><span class="n">dt</span><span class="p">:</span><span class="n">V</span><span class="p">.</span><span class="n">T</span><span class="p">;</span>             <span class="c">% XTick positions</span></div><div class='line' id='LC174'>&nbsp;&nbsp;&nbsp;&nbsp;<span class="n">skip</span>    <span class="p">=</span> <span class="nb">round</span><span class="p">(</span><span class="nb">length</span><span class="p">(</span><span class="n">xticks</span><span class="p">)</span><span class="o">/</span><span class="mi">5</span><span class="p">);</span></div><div class='line' id='LC175'>&nbsp;&nbsp;&nbsp;&nbsp;<span class="n">xticks</span>  <span class="p">=</span> <span class="n">xticks</span><span class="p">(</span><span class="mi">1</span><span class="p">:</span><span class="n">skip</span><span class="p">:</span><span class="k">end</span><span class="p">);</span></div><div class='line' id='LC176'>&nbsp;&nbsp;&nbsp;&nbsp;<span class="n">tvec_o</span>  <span class="p">=</span> <span class="n">xlims</span><span class="p">(</span><span class="mi">1</span><span class="p">):</span><span class="n">xlims</span><span class="p">(</span><span class="mi">2</span><span class="p">);</span>        <span class="c">% only plot stuff within xlims</span></div><div class='line' id='LC177'>&nbsp;&nbsp;&nbsp;&nbsp;<span class="k">if</span> <span class="n">isfield</span><span class="p">(</span><span class="n">V</span><span class="p">,</span><span class="s">&#39;true_n&#39;</span><span class="p">),</span> <span class="n">V</span><span class="p">.</span><span class="n">n</span><span class="p">=</span><span class="n">V</span><span class="p">.</span><span class="n">true_n</span><span class="p">;</span> <span class="k">end</span></div><div class='line' id='LC178'>&nbsp;&nbsp;&nbsp;&nbsp;<span class="k">if</span> <span class="n">isfield</span><span class="p">(</span><span class="n">V</span><span class="p">,</span><span class="s">&#39;n&#39;</span><span class="p">),</span> <span class="n">spt</span><span class="p">=</span><span class="nb">find</span><span class="p">(</span><span class="n">V</span><span class="p">.</span><span class="n">n</span><span class="p">);</span> <span class="k">end</span></div><div class='line' id='LC179'><br/></div><div class='line' id='LC180'>&nbsp;&nbsp;&nbsp;&nbsp;<span class="c">% plot fluorescence data</span></div><div class='line' id='LC181'>&nbsp;&nbsp;&nbsp;&nbsp;<span class="nb">i</span><span class="p">=</span><span class="mi">1</span><span class="p">;</span> <span class="n">h</span><span class="p">(</span><span class="nb">i</span><span class="p">)=</span><span class="n">subplot</span><span class="p">(</span><span class="n">nrows</span><span class="p">,</span><span class="mi">1</span><span class="p">,</span><span class="nb">i</span><span class="p">);</span> <span class="n">hold</span> <span class="n">on</span></div><div class='line' id='LC182'>&nbsp;&nbsp;&nbsp;&nbsp;<span class="n">plot</span><span class="p">(</span><span class="n">tvec_o</span><span class="p">,</span><span class="n">z1</span><span class="p">(</span><span class="n">F</span><span class="p">(</span><span class="n">tvec_o</span><span class="p">)),</span><span class="s">&#39;-k&#39;</span><span class="p">,</span><span class="s">&#39;LineWidth&#39;</span><span class="p">,</span><span class="n">lw</span><span class="p">);</span></div><div class='line' id='LC183'>&nbsp;&nbsp;&nbsp;&nbsp;<span class="n">ylab</span><span class="p">=</span><span class="n">ylabel</span><span class="p">([{</span><span class="s">&#39;Fluorescence&#39;</span><span class="p">}],</span><span class="s">&#39;Interpreter&#39;</span><span class="p">,</span><span class="n">inter</span><span class="p">,</span><span class="s">&#39;FontSize&#39;</span><span class="p">,</span><span class="n">fs</span><span class="p">);</span></div><div class='line' id='LC184'>&nbsp;&nbsp;&nbsp;&nbsp;<span class="n">set</span><span class="p">(</span><span class="n">ylab</span><span class="p">,</span><span class="s">&#39;Rotation&#39;</span><span class="p">,</span><span class="mi">0</span><span class="p">,</span><span class="s">&#39;HorizontalAlignment&#39;</span><span class="p">,</span><span class="s">&#39;right&#39;</span><span class="p">,</span><span class="s">&#39;verticalalignment&#39;</span><span class="p">,</span><span class="s">&#39;middle&#39;</span><span class="p">)</span></div><div class='line' id='LC185'>&nbsp;&nbsp;&nbsp;&nbsp;<span class="n">set</span><span class="p">(</span><span class="n">gca</span><span class="p">,</span><span class="s">&#39;YTick&#39;</span><span class="p">,[],</span><span class="s">&#39;YTickLabel&#39;</span><span class="p">,[])</span></div><div class='line' id='LC186'>&nbsp;&nbsp;&nbsp;&nbsp;<span class="n">set</span><span class="p">(</span><span class="n">gca</span><span class="p">,</span><span class="s">&#39;XTick&#39;</span><span class="p">,</span><span class="n">xticks</span><span class="p">,</span><span class="s">&#39;XTickLabel&#39;</span><span class="p">,[])</span></div><div class='line' id='LC187'>&nbsp;&nbsp;&nbsp;&nbsp;<span class="n">axis</span><span class="p">([</span><span class="n">xlims</span> <span class="mi">0</span> <span class="mf">1.1</span><span class="p">])</span></div><div class='line' id='LC188'><br/></div><div class='line' id='LC189'>&nbsp;&nbsp;&nbsp;&nbsp;<span class="c">% plot fast-oopsi output</span></div><div class='line' id='LC190'>&nbsp;&nbsp;&nbsp;&nbsp;<span class="k">if</span> <span class="n">V</span><span class="p">.</span><span class="n">fast_iter_max</span><span class="o">&gt;</span><span class="mi">0</span></div><div class='line' id='LC191'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span class="nb">i</span><span class="p">=</span><span class="nb">i</span><span class="o">+</span><span class="mi">1</span><span class="p">;</span> <span class="n">h</span><span class="p">(</span><span class="nb">i</span><span class="p">)=</span><span class="n">subplot</span><span class="p">(</span><span class="n">nrows</span><span class="p">,</span><span class="mi">1</span><span class="p">,</span><span class="nb">i</span><span class="p">);</span> <span class="n">hold</span> <span class="n">on</span><span class="p">,</span></div><div class='line' id='LC192'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span class="n">n_fast</span><span class="p">=</span><span class="n">fast</span><span class="p">.</span><span class="n">n</span><span class="o">/</span><span class="n">max</span><span class="p">(</span><span class="n">fast</span><span class="p">.</span><span class="n">n</span><span class="p">);</span></div><div class='line' id='LC193'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span class="n">spts</span><span class="p">=</span><span class="nb">find</span><span class="p">(</span><span class="n">n_fast</span><span class="o">&gt;</span><span class="mf">1e-3</span><span class="p">);</span></div><div class='line' id='LC194'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span class="n">stem</span><span class="p">(</span><span class="n">spts</span><span class="p">,</span><span class="n">n_fast</span><span class="p">(</span><span class="n">spts</span><span class="p">),</span><span class="s">&#39;Marker&#39;</span><span class="p">,</span><span class="s">&#39;none&#39;</span><span class="p">,</span><span class="s">&#39;LineWidth&#39;</span><span class="p">,</span><span class="n">sw</span><span class="p">,</span><span class="s">&#39;Color&#39;</span><span class="p">,</span><span class="s">&#39;k&#39;</span><span class="p">)</span></div><div class='line' id='LC195'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span class="k">if</span> <span class="n">isfield</span><span class="p">(</span><span class="n">V</span><span class="p">,</span><span class="s">&#39;n&#39;</span><span class="p">),</span></div><div class='line' id='LC196'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span class="n">stem</span><span class="p">(</span><span class="n">spt</span><span class="p">,</span><span class="n">V</span><span class="p">.</span><span class="n">n</span><span class="p">(</span><span class="n">spt</span><span class="p">)</span><span class="o">/</span><span class="n">max</span><span class="p">(</span><span class="n">V</span><span class="p">.</span><span class="n">n</span><span class="p">(</span><span class="n">spt</span><span class="p">))</span><span class="o">+</span><span class="mf">0.1</span><span class="p">,</span><span class="s">&#39;Marker&#39;</span><span class="p">,</span><span class="s">&#39;v&#39;</span><span class="p">,</span><span class="s">&#39;MarkerSize&#39;</span><span class="p">,</span><span class="n">ms</span><span class="p">,</span><span class="s">&#39;LineStyle&#39;</span><span class="p">,</span><span class="s">&#39;none&#39;</span><span class="p">,</span><span class="s">&#39;MarkerFaceColor&#39;</span><span class="p">,</span><span class="n">gray</span><span class="p">,</span><span class="s">&#39;MarkerEdgeColor&#39;</span><span class="p">,</span><span class="n">gray</span><span class="p">)</span></div><div class='line' id='LC197'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span class="k">end</span></div><div class='line' id='LC198'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span class="n">axis</span><span class="p">([</span><span class="n">xlims</span> <span class="mi">0</span> <span class="mf">1.1</span><span class="p">])</span></div><div class='line' id='LC199'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span class="n">hold</span> <span class="n">off</span><span class="p">,</span></div><div class='line' id='LC200'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span class="n">ylab</span><span class="p">=</span><span class="n">ylabel</span><span class="p">([{</span><span class="s">&#39;fast&#39;</span><span class="p">};</span> <span class="p">{</span><span class="s">&#39;filter&#39;</span><span class="p">}],</span><span class="s">&#39;Interpreter&#39;</span><span class="p">,</span><span class="n">inter</span><span class="p">,</span><span class="s">&#39;FontSize&#39;</span><span class="p">,</span><span class="n">fs</span><span class="p">);</span></div><div class='line' id='LC201'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span class="n">set</span><span class="p">(</span><span class="n">ylab</span><span class="p">,</span><span class="s">&#39;Rotation&#39;</span><span class="p">,</span><span class="mi">0</span><span class="p">,</span><span class="s">&#39;HorizontalAlignment&#39;</span><span class="p">,</span><span class="s">&#39;right&#39;</span><span class="p">,</span><span class="s">&#39;verticalalignment&#39;</span><span class="p">,</span><span class="s">&#39;middle&#39;</span><span class="p">)</span></div><div class='line' id='LC202'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span class="n">set</span><span class="p">(</span><span class="n">gca</span><span class="p">,</span><span class="s">&#39;YTick&#39;</span><span class="p">,</span><span class="mi">0</span><span class="p">:</span><span class="mi">2</span><span class="p">,</span><span class="s">&#39;YTickLabel&#39;</span><span class="p">,[])</span></div><div class='line' id='LC203'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span class="n">set</span><span class="p">(</span><span class="n">gca</span><span class="p">,</span><span class="s">&#39;XTick&#39;</span><span class="p">,</span><span class="n">xticks</span><span class="p">,</span><span class="s">&#39;XTickLabel&#39;</span><span class="p">,[])</span></div><div class='line' id='LC204'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span class="n">box</span> <span class="n">off</span></div><div class='line' id='LC205'>&nbsp;&nbsp;&nbsp;&nbsp;<span class="k">end</span></div><div class='line' id='LC206'><br/></div><div class='line' id='LC207'>&nbsp;&nbsp;&nbsp;&nbsp;<span class="c">% plot smc-oopsi output</span></div><div class='line' id='LC208'>&nbsp;&nbsp;&nbsp;&nbsp;<span class="k">if</span> <span class="n">V</span><span class="p">.</span><span class="n">smc_iter_max</span><span class="o">&gt;</span><span class="mi">0</span></div><div class='line' id='LC209'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span class="nb">i</span><span class="p">=</span><span class="nb">i</span><span class="o">+</span><span class="mi">1</span><span class="p">;</span> <span class="n">h</span><span class="p">(</span><span class="nb">i</span><span class="p">)=</span><span class="n">subplot</span><span class="p">(</span><span class="n">nrows</span><span class="p">,</span><span class="mi">1</span><span class="p">,</span><span class="nb">i</span><span class="p">);</span> <span class="n">hold</span> <span class="n">on</span><span class="p">,</span></div><div class='line' id='LC210'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span class="n">spts</span><span class="p">=</span><span class="nb">find</span><span class="p">(</span><span class="n">smc</span><span class="p">.</span><span class="n">E</span><span class="p">.</span><span class="n">nbar</span><span class="o">&gt;</span><span class="mf">1e-3</span><span class="p">);</span></div><div class='line' id='LC211'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span class="n">stem</span><span class="p">(</span><span class="n">spts</span><span class="p">,</span><span class="n">smc</span><span class="p">.</span><span class="n">E</span><span class="p">.</span><span class="n">nbar</span><span class="p">(</span><span class="n">spts</span><span class="p">),</span><span class="s">&#39;Marker&#39;</span><span class="p">,</span><span class="s">&#39;none&#39;</span><span class="p">,</span><span class="s">&#39;LineWidth&#39;</span><span class="p">,</span><span class="n">sw</span><span class="p">,</span><span class="s">&#39;Color&#39;</span><span class="p">,</span><span class="s">&#39;k&#39;</span><span class="p">)</span></div><div class='line' id='LC212'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span class="k">if</span> <span class="n">isfield</span><span class="p">(</span><span class="n">V</span><span class="p">,</span><span class="s">&#39;n&#39;</span><span class="p">),</span></div><div class='line' id='LC213'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span class="n">stem</span><span class="p">(</span><span class="n">spt</span><span class="p">,</span><span class="n">V</span><span class="p">.</span><span class="n">n</span><span class="p">(</span><span class="n">spt</span><span class="p">)</span><span class="o">+</span><span class="mf">0.1</span><span class="p">,</span><span class="s">&#39;Marker&#39;</span><span class="p">,</span><span class="s">&#39;v&#39;</span><span class="p">,</span><span class="s">&#39;MarkerSize&#39;</span><span class="p">,</span><span class="n">ms</span><span class="p">,</span><span class="s">&#39;LineStyle&#39;</span><span class="p">,</span><span class="s">&#39;none&#39;</span><span class="p">,</span><span class="s">&#39;MarkerFaceColor&#39;</span><span class="p">,</span><span class="n">gray</span><span class="p">,</span><span class="s">&#39;MarkerEdgeColor&#39;</span><span class="p">,</span><span class="n">gray</span><span class="p">)</span></div><div class='line' id='LC214'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span class="k">end</span></div><div class='line' id='LC215'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span class="n">axis</span><span class="p">([</span><span class="n">xlims</span> <span class="mi">0</span> <span class="mf">1.1</span><span class="p">])</span></div><div class='line' id='LC216'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span class="n">hold</span> <span class="n">off</span><span class="p">,</span></div><div class='line' id='LC217'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span class="n">ylab</span><span class="p">=</span><span class="n">ylabel</span><span class="p">([{</span><span class="s">&#39;smc&#39;</span><span class="p">};</span> <span class="p">{</span><span class="s">&#39;filter&#39;</span><span class="p">}],</span><span class="s">&#39;Interpreter&#39;</span><span class="p">,</span><span class="n">inter</span><span class="p">,</span><span class="s">&#39;FontSize&#39;</span><span class="p">,</span><span class="n">fs</span><span class="p">);</span></div><div class='line' id='LC218'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span class="n">set</span><span class="p">(</span><span class="n">ylab</span><span class="p">,</span><span class="s">&#39;Rotation&#39;</span><span class="p">,</span><span class="mi">0</span><span class="p">,</span><span class="s">&#39;HorizontalAlignment&#39;</span><span class="p">,</span><span class="s">&#39;right&#39;</span><span class="p">,</span><span class="s">&#39;verticalalignment&#39;</span><span class="p">,</span><span class="s">&#39;middle&#39;</span><span class="p">)</span></div><div class='line' id='LC219'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span class="n">set</span><span class="p">(</span><span class="n">gca</span><span class="p">,</span><span class="s">&#39;YTick&#39;</span><span class="p">,</span><span class="mi">0</span><span class="p">:</span><span class="mi">2</span><span class="p">,</span><span class="s">&#39;YTickLabel&#39;</span><span class="p">,[])</span></div><div class='line' id='LC220'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span class="n">set</span><span class="p">(</span><span class="n">gca</span><span class="p">,</span><span class="s">&#39;XTick&#39;</span><span class="p">,</span><span class="n">xticks</span><span class="p">,</span><span class="s">&#39;XTickLabel&#39;</span><span class="p">,[])</span></div><div class='line' id='LC221'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span class="n">box</span> <span class="n">off</span></div><div class='line' id='LC222'>&nbsp;&nbsp;&nbsp;&nbsp;<span class="k">end</span></div><div class='line' id='LC223'><br/></div><div class='line' id='LC224'>&nbsp;&nbsp;&nbsp;&nbsp;<span class="c">% label last subplot</span></div><div class='line' id='LC225'>&nbsp;&nbsp;&nbsp;&nbsp;<span class="n">set</span><span class="p">(</span><span class="n">gca</span><span class="p">,</span><span class="s">&#39;XTick&#39;</span><span class="p">,</span><span class="n">xticks</span><span class="p">,</span><span class="s">&#39;XTickLabel&#39;</span><span class="p">,</span><span class="nb">round</span><span class="p">(</span><span class="n">xticks</span><span class="o">*</span><span class="n">V</span><span class="p">.</span><span class="n">dt</span><span class="o">*</span><span class="mi">100</span><span class="p">)</span><span class="o">/</span><span class="mi">100</span><span class="p">)</span></div><div class='line' id='LC226'>&nbsp;&nbsp;&nbsp;&nbsp;<span class="n">xlabel</span><span class="p">(</span><span class="s">&#39;Time (sec)&#39;</span><span class="p">,</span><span class="s">&#39;FontSize&#39;</span><span class="p">,</span><span class="n">fs</span><span class="p">)</span></div><div class='line' id='LC227'>&nbsp;&nbsp;&nbsp;&nbsp;<span class="n">linkaxes</span><span class="p">(</span><span class="n">h</span><span class="p">,</span><span class="s">&#39;x&#39;</span><span class="p">)</span></div><div class='line' id='LC228'><br/></div><div class='line' id='LC229'>&nbsp;&nbsp;&nbsp;&nbsp;<span class="c">% print fig</span></div><div class='line' id='LC230'>&nbsp;&nbsp;&nbsp;&nbsp;<span class="k">if</span> <span class="n">V</span><span class="p">.</span><span class="n">save</span></div><div class='line' id='LC231'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span class="n">wh</span><span class="p">=[</span><span class="mi">7</span> <span class="mi">3</span><span class="p">];</span>   <span class="c">%width and height</span></div><div class='line' id='LC232'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span class="n">set</span><span class="p">(</span><span class="n">gcf</span><span class="p">,</span><span class="s">&#39;PaperSize&#39;</span><span class="p">,</span><span class="n">wh</span><span class="p">,</span><span class="s">&#39;PaperPosition&#39;</span><span class="p">,[</span><span class="mi">0</span> <span class="mi">0</span> <span class="n">wh</span><span class="p">],</span><span class="s">&#39;Color&#39;</span><span class="p">,</span><span class="s">&#39;w&#39;</span><span class="p">);</span></div><div class='line' id='LC233'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span class="n">print</span><span class="p">(</span><span class="s">&#39;-depsc&#39;</span><span class="p">,</span><span class="n">V</span><span class="p">.</span><span class="n">name_fig</span><span class="p">)</span></div><div class='line' id='LC234'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span class="n">print</span><span class="p">(</span><span class="s">&#39;-dpdf&#39;</span><span class="p">,</span><span class="n">V</span><span class="p">.</span><span class="n">name_fig</span><span class="p">)</span></div><div class='line' id='LC235'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span class="n">saveas</span><span class="p">(</span><span class="n">fig</span><span class="p">,</span><span class="n">V</span><span class="p">.</span><span class="n">name_fig</span><span class="p">)</span></div><div class='line' id='LC236'>&nbsp;&nbsp;&nbsp;&nbsp;<span class="k">end</span></div><div class='line' id='LC237'><span class="k">end</span></div></pre></div></td>
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
      <li>&copy; 2014 <span title="0.12450s from github-fe137-cp1-prd.iad.github.net">GitHub</span>, Inc.</li>
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

