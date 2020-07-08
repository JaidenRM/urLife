import './provider/cloud_firestore.dart';
import './provider/local_cache.dart';
import './interfaces/data_retrieval_interface.dart';

class DataFactory {
  //remote storage
  CloudFirestore _cloudFirestore;
  //local storage
  LocalCache _localCache;
  //active 
  DataRetrieval dataSource;

  //look at caching these sources and using factory to save reinitialising them
  DataFactory() {
    _cloudFirestore = CloudFirestore();
    _localCache = LocalCache();
    _assignDataSource();
  }
  
  //add logic to decide which data source to use
  void _assignDataSource() {
    dataSource = _cloudFirestore;
  }
}