import './provider/cloud_firestore.dart';
import './provider/local_cache.dart';
import './interfaces/data_retrieval_interface.dart';

class DataFactory {
  static DataFactory _dataFactory;
  //remote storage
  CloudFirestore _cloudFirestore;
  //local storage
  LocalCache _localCache;
  //active 
  DataRetrieval dataSource;

  //look at caching these sources and using factory to save reinitialising them
  factory DataFactory() {
    if(_dataFactory == null)
      _dataFactory = DataFactory._create(LocalCache(), CloudFirestore());
    
    return _dataFactory;
  }

  DataFactory._create(LocalCache localCache, CloudFirestore cloudFirestore) {
    _cloudFirestore = cloudFirestore;
    _localCache = localCache;
    _assignDataSource();
  }

  //used to force the factory to re-evaluate which data source it should be using
  DataFactory.forceRefresh() {
    if(_cloudFirestore == null)
      _cloudFirestore = CloudFirestore();
    if(_localCache == null)
      _localCache = LocalCache();

    _assignDataSource();
  }
  
  //add logic to decide which data source to use
  void _assignDataSource() {
    dataSource = _cloudFirestore;
  }
}