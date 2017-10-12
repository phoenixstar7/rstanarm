  // prior family: 0 = none, 1 = normal, 2 = student_t, 3 = hs, 4 = hs_plus, 
  //   5 = laplace, 6 = lasso
  int<lower=0,upper=6> a_prior_dist;

  // data for association structure
  int<lower=0> a_K;                     // num. of association parameters
  vector[a_K] a_xbar;                   // used for centering assoc terms
  int<lower=0,upper=1> assoc;           // 0 = no assoc structure, 1 = any assoc structure
  int<lower=0,upper=1> assoc_uses[6,M]; // which components are required to build association terms
  int<lower=0,upper=1> has_assoc[16,M]; // which association terms does each submodel use
  int<lower=0> sum_size_which_b;        // num. of shared random effects
  int<lower=0> size_which_b[M];         // num. of shared random effects for each long submodel
  int<lower=1> which_b_zindex[sum_size_which_b]; // which random effects are shared for each long submodel
  int<lower=0> sum_size_which_coef;     // num. of shared random effects incl fixed component
  int<lower=0> size_which_coef[M];      // num. of shared random effects incl fixed component for each long submodel
  int<lower=1> which_coef_zindex[sum_size_which_coef]; // which random effects are shared incl fixed component
  int<lower=1> which_coef_xindex[sum_size_which_coef]; // which fixed effects are shared
  int<lower=0,upper=a_K> sum_a_K_data;  // total num pars used in assoc*data interactions
  int<lower=0,upper=sum_a_K_data> a_K_data[M*4]; // num pars used in assoc*data interactions, by submodel and by ev/es/mv/ms interactions
  int<lower=0> sum_size_which_interactions; // total num pars used in assoc*assoc interactions
  int<lower=0,upper=sum_size_which_interactions> size_which_interactions[M*4]; // num pars used in assoc*assoc interactions, by submodel and by evev/evmv/mvev/mvmv interactions
  int<lower=1> which_interactions[sum_size_which_interactions];  // which terms to interact with

  //---- data for calculating eta in GK quadrature
  
    int<lower=0> nrow_y_Xq[M];      // num. rows in long. predictor matrix at quadpoints
    int<lower=0> idx_q[M,2];        // indices of first and last rows in eta at quadpoints
  
    // fe design matrix at quadpoints
    matrix[nrow_y_Xq*assoc_uses[1,1],yK[1]] y1_xq_eta; 
    matrix[nrow_y_Xq*assoc_uses[1,2],yK[2]] y2_xq_eta; 
    matrix[nrow_y_Xq*assoc_uses[1,3],yK[3]] y3_xq_eta; 
    
    // re design matrix at quadpoints, group factor 1
    vector[bK1_len[1] > 0 ? nrow_y_Xq[1] : 0] y1_z1q_eta[bK1_len[1]]; 
    vector[bK1_len[2] > 0 ? nrow_y_Xq[2] : 0] y2_z1q_eta[bK1_len[2]];
    vector[bK1_len[3] > 0 ? nrow_y_Xq[3] : 0] y3_z1q_eta[bK1_len[3]];
    int<lower=0> y1_z1q_id_eta[bK1_len[1] > 0 ? nrow_y_Xq[1] : 0]; 
    int<lower=0> y2_z1q_id_eta[bK1_len[2] > 0 ? nrow_y_Xq[2] : 0]; 
    int<lower=0> y3_z1q_id_eta[bK1_len[3] > 0 ? nrow_y_Xq[3] : 0]; 

    // re design matrix at quadpoints, group factor 2
    vector[bK2_len[1] > 0 ? nrow_y_Xq[1] : 0] y1_z2q_eta[bK2_len[1]]; 
    vector[bK2_len[2] > 0 ? nrow_y_Xq[2] : 0] y2_z2q_eta[bK2_len[2]];
    vector[bK2_len[3] > 0 ? nrow_y_Xq[3] : 0] y3_z2q_eta[bK2_len[3]];
    int<lower=0> y1_z2q_id_eta[bK2_len[1] > 0 ? nrow_y_Xq[1] : 0]; 
    int<lower=0> y2_z2q_id_eta[bK2_len[2] > 0 ? nrow_y_Xq[2] : 0]; 
    int<lower=0> y3_z2q_id_eta[bK2_len[3] > 0 ? nrow_y_Xq[3] : 0]; 
      
  //---- data for calculating derivative of eta in GK quadrature
    
    // fe design matrix at quadpoints
    matrix[nrow_y_Xq*assoc_uses[2,1],yK[1]] y1_xq_deta; 
    matrix[nrow_y_Xq*assoc_uses[2,2],yK[2]] y2_xq_deta; 
    matrix[nrow_y_Xq*assoc_uses[2,3],yK[3]] y3_xq_deta; 
    
    // re design matrix at quadpoints, group factor 1
    vector[assoc_uses[2,1] == 1 && bK1_len[1] > 0 ? nrow_y_Xq[1] : 0] y1_z1q_deta[bK1_len[1]]; 
    vector[assoc_uses[2,2] == 1 && bK1_len[2] > 0 ? nrow_y_Xq[2] : 0] y2_z1q_deta[bK1_len[2]];
    vector[assoc_uses[2,3] == 1 && bK1_len[3] > 0 ? nrow_y_Xq[3] : 0] y3_z1q_deta[bK1_len[3]];
    int<lower=0> y1_z1q_id_deta[assoc_uses[2,1] == 1 && bK1_len[1] > 0 ? nrow_y_Xq[1] : 0]; 
    int<lower=0> y2_z1q_id_deta[assoc_uses[2,2] == 1 && bK1_len[2] > 0 ? nrow_y_Xq[2] : 0]; 
    int<lower=0> y3_z1q_id_deta[assoc_uses[2,3] == 1 && bK1_len[3] > 0 ? nrow_y_Xq[3] : 0]; 

    // re design matrix at quadpoints, group factor 2
    vector[assoc_uses[2,1] == 1 && bK2_len[1] > 0 ? nrow_y_Xq[1] : 0] y1_z2q_deta[bK2_len[1]]; 
    vector[assoc_uses[2,2] == 1 && bK2_len[2] > 0 ? nrow_y_Xq[2] : 0] y2_z2q_deta[bK2_len[2]];
    vector[assoc_uses[2,3] == 1 && bK2_len[3] > 0 ? nrow_y_Xq[3] : 0] y3_z2q_deta[bK2_len[3]];
    int<lower=0> y1_z2q_id_deta[assoc_uses[2,1] == 1 && bK2_len[1] > 0 ? nrow_y_Xq[1] : 0]; 
    int<lower=0> y2_z2q_id_deta[assoc_uses[2,2] == 1 && bK2_len[2] > 0 ? nrow_y_Xq[2] : 0]; 
    int<lower=0> y3_z2q_id_deta[assoc_uses[2,3] == 1 && bK2_len[3] > 0 ? nrow_y_Xq[3] : 0]; 

  //---- data for calculating integral of eta in GK quadrature

    // fe design matrix at quadpoints
    matrix[nrow_y_Xq_auc*assoc_uses[3,1],yK[1]] y1_xq_ieta; 
    matrix[nrow_y_Xq_auc*assoc_uses[3,2],yK[2]] y2_xq_ieta; 
    matrix[nrow_y_Xq_auc*assoc_uses[3,3],yK[3]] y3_xq_ieta; 
    
    // re design matrix at quadpoints, group factor 1
    vector[assoc_uses[3,1] == 1 && bK1_len[1] > 0 ? nrow_y_Xq_auc[1] : 0] y1_z1q_ieta[bK1_len[1]]; 
    vector[assoc_uses[3,2] == 1 && bK1_len[2] > 0 ? nrow_y_Xq_auc[2] : 0] y2_z1q_ieta[bK1_len[2]];
    vector[assoc_uses[3,3] == 1 && bK1_len[3] > 0 ? nrow_y_Xq_auc[3] : 0] y3_z1q_ieta[bK1_len[3]];
    int<lower=0> y1_z1q_id_ieta[assoc_uses[3,1] == 1 && bK1_len[1] > 0 ? nrow_y_Xq_auc[1] : 0]; 
    int<lower=0> y2_z1q_id_ieta[assoc_uses[3,2] == 1 && bK1_len[2] > 0 ? nrow_y_Xq_auc[2] : 0]; 
    int<lower=0> y3_z1q_id_ieta[assoc_uses[3,3] == 1 && bK1_len[3] > 0 ? nrow_y_Xq_auc[3] : 0]; 

    // re design matrix at quadpoints, group factor 2
    vector[assoc_uses[3,1] == 1 && bK2_len[1] > 0 ? nrow_y_Xq_auc[1] : 0] y1_z2q_ieta[bK2_len[1]]; 
    vector[assoc_uses[3,2] == 1 && bK2_len[2] > 0 ? nrow_y_Xq_auc[2] : 0] y2_z2q_ieta[bK2_len[2]];
    vector[assoc_uses[3,3] == 1 && bK2_len[3] > 0 ? nrow_y_Xq_auc[3] : 0] y3_z2q_ieta[bK2_len[3]];
    int<lower=0> y1_z2q_id_ieta[assoc_uses[3,1] == 1 && bK2_len[1] > 0 ? nrow_y_Xq_auc[1] : 0]; 
    int<lower=0> y2_z2q_id_ieta[assoc_uses[3,2] == 1 && bK2_len[2] > 0 ? nrow_y_Xq_auc[2] : 0]; 
    int<lower=0> y3_z2q_id_ieta[assoc_uses[3,3] == 1 && bK2_len[3] > 0 ? nrow_y_Xq_auc[3] : 0]; 

  //---- data for calculating assoc*data interactions in GK quadrature
  
    // design matrix for interacting with ev/es/mv/ms at quadpoints
    matrix[sum(nrow_y_Xq),sum_a_K_data] y_Xq_data; 
  
  //---- data for combining lower level units clustered within patients
  
    int<lower=0,upper=1> has_clust[M]; // 1 = has clustering below patient level
    int<lower=0> clust_ids; 
